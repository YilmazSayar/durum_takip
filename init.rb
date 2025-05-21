require 'redmine'

Redmine::Plugin.register :durum_takip do
  name 'Durum Takip Eklentisi'
  author 'Yilmaz Sayar'
  description 'Redmine projeleri için iş durumlarininn yaşam döngüsünü gösteren eklenti.'
  version '0.0.1'
  url 'https://github.com/YilmazSayar/durum_takip'  # GitHub adresin
  author_url 'https://github.com/YilmazSayar'

  # Proje modülü olarak tanımlama - aktif/pasif yapılabilir
  project_module :durum_takip do
    permission :view_durum_takip, { durum_takip: [:index, :show] }, public: true
  end

  # Proje menüsüne yeni bir sekme ekleme
menu :project_menu, :durum_takip,
     { controller: 'durum_takip', action: 'index' },
     caption: 'Durum Takip',
     after: :wiki,
     param: :project_id,
     if: Proc.new { |project| User.current.allowed_to?(:view_durum_takip, project) }


end
