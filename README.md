 (Ruby on Rails)

JWT tabanlı kimlik doğrulama, kullanıcı içerikleri ve topluluk etkileşimi sunan bir Ruby on Rails API uygulaması. Kullanıcılar gönderi oluşturup yorumlayabilir, ders/videolarla içeriklerini kategorize edebilir ve analiz/rapor kayıtları tutabilir.

## İçindekiler
1. [Özellikler](#özellikler)
2. [Teknoloji Yığını](#teknoloji-yığını)
3. [Domain Modelleri ve İlişkiler](#domain-modelleri-ve-ilişkiler)
4. [Kimlik Doğrulama Akışı](#kimlik-doğrulama-akışı)
5. [Postman ile Test](#postman-ile-test)
6. [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)
7. [Faydalı Komutlar](#faydalı-komutlar)

## Özellikler
- `Api::V1::AuthController` üzerinden JWT destekli kayıt/giriş ve token doğrulama.
- Kullanıcıların gönderi, yorum, analiz, rapor, ders ve video üretip yönetebilmesi.
- Gönderilerin dersler (`Course`) ve konular (`Subject`) ile ilişkilendirilmesi.
- Varsayılan sıralama ve doğrulamalarla içerik kalitesinin korunması.
- `JsonWebToken` yardımcı sınıfı ile token üretimi, `ApplicationController` filtreleri ile merkezi erişim kontrolü.

## Teknoloji Yığını
- Ruby 3.4.7
- Rails 7.1.5.2 (API modu + ActionController::API tabanı)
- SQLite3 (varsayılan geliştirme veritabanı)
- JWT 2.7.x (kimlik doğrulama)
- Puma (varsayılan uygulama sunucusu)
- Postman (manuel/otomasyon testleri)

## Domain Modelleri ve İlişkiler
- **User** → `has_many :posts, :comments, :analyses, :reports, :courses, :videos` (kullanıcı silinince ilgili kayıtlar temizlenir).@app/models/user.rb#1-8
- **Post** → `belongs_to :user`, isteğe bağlı `belongs_to :subject` ve `:course`, ayrıca `has_many :comments` & `:analyses` (dependent destroy).@app/models/post.rb#1-8
- **Comment** → Her yorum bir kullanıcı ve posta bağlı; varsayılan olarak kronolojik sıralanır.@app/models/comment.rb#1-10
- **Analysis / Report** → Kullanıcıya ait içerik değerlendirmesi/raporları tutar.@app/models/analysis.rb#1-5 @app/models/report.rb#1-4
- **Course / Subject** → Gönderileri kategorize eder; kurslar videolarla ilişkili, silinince ilişkiler `nullify` edilir.@app/models/course.rb#1-4 @app/models/subject.rb#1-4
- **Video** → Kursa bağlı eğitim içerikleri (model dosyası benzer şekilde `belongs_to :course`).

## Kimlik Doğrulama Akışı
1. Kullanıcı kayıt veya giriş isteği `Api::V1::AuthController` tarafından karşılanır.
2. Başarılı işlemde `JsonWebToken.encode` ile `Authorization: Bearer <token>` formatında kullanılacak token üretilir.@app/controllers/api/v1/auth_controller.rb#6-38 @app/lib/json_web_token.rb#1-16
3. Tüm diğer controller eylemleri `ApplicationController#authenticate_request` filtresiyle token doğrulandıktan sonra çalışır; hatalı veya süresi dolmuş tokenlar standart JSON hata mesajı döndürür.@app/controllers/application_controller.rb#1-54

## Postman ile Test
- `script/generate_postman_token.rb` betiği, Postman senaryolarında kullanılacak örnek kullanıcıyı ve JWT tokenını oluşturur. Çalıştırmak için:

  ```bash
  rails runner script/generate_postman_token.rb
  ```

- Çıktıdaki kullanıcı kimlik bilgilerini Postman "Environment" değişkenlerine ekleyebilir, `Authorization` başlığında Bearer token olarak kullanabilirsiniz.
- Koleksiyon testlerinde kayıt, giriş, gönderi oluşturma ve yorum uç noktaları manuel olarak doğrulandı.

## Kurulum ve Çalıştırma

### Gereksinimler
- Ruby 3.4.7
- Rails 7.1.5.2
- SQLite3 (veya tercih ettiğiniz ActiveRecord uyumlu veritabanı)

### Adımlar
```bash
# Bağımlılıkları kurun
bundle install

# Veritabanını hazırlayın
rails db:create
rails db:migrate

# (İsteğe bağlı) örnek veri/Token için Postman betiğini çalıştırın
rails runner script/generate_postman_token.rb

# Uygulamayı başlatın
rails server
```

Sunucu `http://localhost:3000` üzerinde ayağa kalkar. API taleplerinde `Authorization` başlığına geçerli JWT eklemeyi unutmayın.

## Faydalı Komutlar
```bash
rails server          # Sunucuyu başlat
rails console         # Rails konsolunu aç
rails db:migrate      # Migrasyonları çalıştır
rails db:reset        # Veritabanını sıfırla
rails routes          # Uç noktaları görüntüle
bundle exec rubocop   # (Varsa) kod stil kontrolleri
```

---

**Durum**: ✅ Aktif ve geliştirmeye açık
