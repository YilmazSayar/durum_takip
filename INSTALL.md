# Durum Takip Eklentisi Kurulum Rehberi

Bu belge, Durum Takip Redmine eklentisinin sıfırdan kurulumunu açıklamaktadır.

## 1. Redmine Kurulumu

Eklenti, Redmine 5.x sürümü ile test edilmiştir. Eğer sisteminizde Redmine kurulu değilse [Redmine resmi kurulum kılavuzunu](https://www.redmine.org/projects/redmine/wiki/RedmineInstall) izleyebilirsiniz.

## 2. Eklentinin Redmine'a Eklenmesi

Eklenti dosyasını Redmine dizininin altındaki `plugins/` klasörüne kopyalayın:

```bash
cp -r durum_takip/ /path/to/redmine/plugins/
```

## 3. Veritabanı İşlemleri

Eklentinin çalışabilmesi için veritabanı işlemlerinin yapılması gerekir. Redmine ana dizinine gidin ve aşağıdaki komutları çalıştırın:

```bash
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

## 4. Sunucuyu Başlatma

```bash
bundle exec rails server -e production
```

Ardından tarayıcınızdan `http://localhost:3000` adresine giderek Redmine'a erişebilirsiniz.

## 5. Eklentiyi Kullanma

Redmine üzerinde bir proje açtıktan sonra üst menüde "Durum Takip" sekmesi görünecektir. Bu sekmeye tıklayarak eklentiyi kullanabilirsiniz.


## Gerekli Araçların Kurulumu

### RubyGems, Bundler ve Rake Kurulumu

**1. Ruby ve RubyGems kurulmalı**

Redmine, Ruby ile yazılmış bir uygulamadır. Ruby'yi sistemine kurduğunda, genellikle `gem` komutu da beraber gelir. Kontrol etmek için terminale şunu yaz:

```bash
ruby -v
gem -v
```

**2. Bundler Kurulumu**

Redmine projelerinde bağımlılıkları (gems) yüklemek için `bundler` kullanılır. Kurulumu için:

```bash
gem install bundler
```

Daha sonra bağımlılıkları yüklemek için proje dizinindeyken şunu çalıştırabilirsin:

```bash
bundle install
```

**3. Rake Kurulumu**

`rake`, Ruby projelerinde görev çalıştırmak için kullanılan bir araçtır. Çoğu zaman `bundle install` ile birlikte gelir ama ayrı kurman gerekirse:

```bash
gem install rake
```

Kurulduktan sonra veri tabanı gibi işlemleri yapmak için şunları kullanabilirsin:

```bash
bundle exec rake db:migrate RAILS_ENV=production
```
