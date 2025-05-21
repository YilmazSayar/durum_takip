class DurumTakipController < ApplicationController
  include SortHelper  
  helper :sort

  before_action :find_project

  def index
    sort_init 'issues.subject', 'asc'
    sort_update(
      'issue' => 'issues.subject',
      'category' => 'issue_categories.name',
      'assigned_to' => 'issues.assigned_to_id'
    )

    @issues = @project.issues
                      .joins('LEFT JOIN issue_categories ON issue_categories.id = issues.category_id')
                      .includes(:journals, :status, :tracker, :category)
                      .order(sort_clause)

    @issues_status_durations = {}
    @issues_history_data = {}
    @issues.each do |issue|
      status_changes = issue.journals.select do |journal|
        journal.details.any? { |detail| detail.prop_key == 'status_id' }
      end.sort_by(&:created_on)

      previous_time = issue.created_on
      previous_status_id = issue.status_id
      durations = Hash.new(0)
      status_users = Hash.new { |hash, key| hash[key] = [] }

      # Durum süre hesaplama
      status_changes.each do |journal|
        status_change_detail = journal.details.find { |d| d.prop_key == 'status_id' }
        next unless status_change_detail

        duration = journal.created_on - previous_time
        durations[previous_status_id] += duration
        status_users[previous_status_id] << journal.user

        previous_time = journal.created_on
        previous_status_id = status_change_detail.value.to_i
      end

      durations[previous_status_id] += Time.current - previous_time
      status_users[previous_status_id] << issue.assigned_to if issue.assigned_to

      @issues_status_durations[issue.id] = {
        issue: issue,
        durations: durations,
        users: status_users
      }

      # Durum geçmişi
      history = []

      status_changes.each do |journal|
        detail = journal.details.find { |d| d.prop_key == 'status_id' }
        next unless detail

        old_status = IssueStatus.find_by(id: detail.old_value)
        new_status = IssueStatus.find_by(id: detail.value)

        history << {
          time: journal.created_on,
          old_status: old_status&.name || '-',
          new_status: new_status&.name || '-',
          user: journal.user.name
        }
      end

      @issues_history_data[issue.id] = history
    end

    # Grafik verisi hazırlama
    @issues_graph_data = {}

    @issues_status_durations.each do |issue_id, data|
      labels = []
      durations = []

      data[:durations].each do |status_id, duration|
        status = IssueStatus.find_by(id: status_id)
        if status
          labels << status.name
          durations << (duration / 3600).round(2)
        end
      end

      @issues_graph_data[issue_id] = { labels: labels, durations: durations }

      Rails.logger.info "Issue #{issue_id}: Labels=#{labels.inspect}, Durations=#{durations.inspect}"
    end
  end

  private

  def find_project
    @project = Project.find_by(identifier: params[:project_id])
  end

  def sort_column
    columns = {
      'issue' => 'issues.subject',
      'category' => 'issue_categories.name',
      'assigned_to' => 'issues.assigned_to_id'
    }
    columns[params[:sort]] || 'issues.subject'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
