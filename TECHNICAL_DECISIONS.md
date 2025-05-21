# Teknik Kararlar ve Kabuller

Bu belge, Redmine için geliştirilen "Durum Takip" eklentisinin geliştirilmesi sırasında alınan teknik kararlar ve yapılan kabulleri açıklamaktadır.

## 1. Redmine Eklenti Yapısı

Eklenti, Redmine’in resmi eklenti geliştirme yapısına uygun olarak `plugins/` dizini altına yerleştirildi. Bu yapı, Redmine’in eklentileri otomatik olarak tanıyıp yükleyebilmesini sağlar.

## 2. Ruby on Rails Kullanımı

Redmine, Ruby on Rails tabanlı bir uygulamadır. Eklenti de tamamen Rails yapısına uygun olarak geliştirildi. Bu nedenle:

- `Controller`, `View` ve `Model` gibi MVC bileşenleri kullanıldı.
- Redmine’in `ApplicationController` sınıfı temel alındı.
- Active Record ilişkileri ve `includes`, `joins`, `order` gibi performans odaklı sorgular kullanıldı.

## 3. Zaman Dilimi Ayarları

Redmine varsayılan olarak `UTC` zaman diliminde çalışmaktadır. Durum geçiş zamanlarının doğru gösterilmesi için `config/application.rb` dosyasında:

```ruby
config.active_record.default_timezone = :local
```

satırı eklenerek sunucunun yerel saat dilimi kullanılacak şekilde ayarlandı.

## 4. Chart.js Kullanımı

Durum değişikliklerinin görsel olarak sunulabilmesi için eklentiye `Chart.js` kütüphanesi entegre edildi. Bu sayede her işin durumları saat bazında çubuk grafik olarak gösterilebilmektedir.

- Chart.js CDN üzerinden çağrıldı, bu nedenle ek bir kurulum gerekmedi.
- JavaScript kodları view dosyasında yazıldı ve dinamik grafikler oluşturuldu.

## 5. Durum Geçmişi Hesaplama

- Her iş için `Journal` kayıtları incelendi.
- `status_id` içeren değişiklikler tespit edilerek, durum geçişleri ve geçiş zamanları hesaplandı.
- Durumlar arasında geçen süre saat cinsinden hesaplanıp tablo ve grafik olarak gösterildi.

## 6. Erişim Kontrolü

Kullanıcı sadece belirli bir projeye ait işler üzerinde takip gerçekleştirebilir. Bu nedenle `before_action :find_project` filtresi ile proje ID’si kontrol altına alındı.

## 7. Ekstra Yapılandırmalar

Eklentinin doğru çalışabilmesi için aşağıdaki ek yapılandırmalar gerekliydi:

- `config/application.rb` içinde zaman ayarları güncellendi.
- Redmine eklenti klasörünün altına standart yapıda konumlandırıldı.
- `bundle install` ve `rake redmine:plugins:migrate` komutları ile kurulum süreci tamamlandı.

---

## Notlar

- Eklenti tamamen Redmine üzerinde bağımsız ve modüler bir şekilde çalışmaktadır.
- Redmine sürümü 5.x ile test edilmiştir.
- Veritabanı olarak PostgreSQL kullanılmıştır ancak ActiveRecord uyumlu tüm veritabanlarında çalışması beklenmektedir.