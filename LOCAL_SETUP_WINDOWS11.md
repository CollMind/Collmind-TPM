# Windows 11 için Local Kurulum Rehberi

Bu dokümantasyon, CollMind TPM projesini (Backend + Frontend) Windows 11 bilgisayarınızda sıfırdan kurmak için gerekli tüm adımları içerir.

## 📋 İçindekiler

- [Gereksinimler](#gereksinimler)
- [Docker Desktop Kurulumu](#docker-desktop-kurulumu)
- [Node.js Kurulumu](#nodejs-kurulumu)
- [Git Kurulumu](#git-kurulumu)
- [Backend Kurulumu](#backend-kurulumu)
- [Frontend Kurulumu](#frontend-kurulumu)
- [Projeyi Çalıştırma](#projeyi-çalıştırma)
- [Sorun Giderme](#sorun-giderme)

---

## Gereksinimler

Projeyi çalıştırmak için aşağıdaki yazılımların kurulu olması gerekir:

- **Windows 11** (64-bit)
- **Docker Desktop** (PostgreSQL için)
- **Node.js** 20.x LTS
- **npm** (Node.js ile birlikte gelir)
- **Git** (projeyi klonlamak için)
- **En az 8GB RAM** (önerilen: 16GB)
- **En az 20GB boş disk alanı**

---

## Docker Desktop Kurulumu

### Adım 1: WSL 2 Kurulumu (Gerekli)

Docker Desktop, Windows 11'de WSL 2 (Windows Subsystem for Linux) gerektirir.

#### WSL 2 Kurulumunu Kontrol Etme

PowerShell'i **Yönetici olarak** açın (Windows tuşu + X, "Windows PowerShell (Yönetici)" seçin) ve şu komutu çalıştırın:

```powershell
wsl --status
```

Eğer WSL kurulu değilse veya versiyon 2 değilse, aşağıdaki adımları takip edin.

#### WSL 2 Kurulumu

PowerShell'i **Yönetici olarak** açın ve şu komutu çalıştırın:

```powershell
wsl --install
```

Bu komut:
- WSL'yi kurar
- Varsayılan olarak Ubuntu Linux dağıtımını kurar
- WSL 2'yi varsayılan sürüm olarak ayarlar

**Önemli**: Kurulumdan sonra bilgisayarınızı **yeniden başlatmanız** gerekir.

#### WSL 2 Kurulumunu Doğrulama

Bilgisayarı yeniden başlattıktan sonra, PowerShell'i açın ve:

```powershell
wsl --status
```

Çıktı şuna benzer olmalıdır:
```
Default Version: 2
```

WSL versiyonunu kontrol edin:
```powershell
wsl --list --verbose
```

Çıktıda VERSION sütununda "2" görünmelidir.

### Adım 2: Docker Desktop İndirme

1. [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) sayfasına gidin
2. **"Download for Windows"** butonuna tıklayın
3. `Docker Desktop Installer.exe` dosyasını indirin

### Adım 3: Docker Desktop Kurulumu

1. İndirilen `Docker Desktop Installer.exe` dosyasını çalıştırın
2. Kurulum sihirbazını takip edin:
   - **"Use WSL 2 instead of Hyper-V"** seçeneğini işaretleyin (önerilen)
   - Kurulum tamamlandığında **"Close and restart"** butonuna tıklayın
3. Bilgisayarınızı yeniden başlatın (gerekirse)

### Adım 4: Docker Desktop'ı Başlatma

1. Windows Başlat menüsünden **Docker Desktop**'ı açın
2. İlk açılışta Docker Desktop'ın başlaması birkaç dakika sürebilir
3. Sistem tepsinde (system tray) Docker ikonu görünene kadar bekleyin
4. Docker Desktop penceresi açıldığında, **"Accept"** butonuna tıklayarak hizmet şartlarını kabul edin

### Adım 5: Docker Kurulumunu Doğrulama

**PowerShell** veya **Command Prompt**'u açın ve aşağıdaki komutları çalıştırın:

```powershell
docker --version
```

Çıktı şuna benzer olmalıdır:
```
Docker version 24.0.0, build abc123
```

Docker Compose'u kontrol edin:

```powershell
docker compose version
```

Çıktı şuna benzer olmalıdır:
```
Docker Compose version v2.20.0
```

Docker'ın çalıştığını test edin:

```powershell
docker run hello-world
```

Bu komut bir test container'ı çalıştırır ve başarılı olursa Docker düzgün çalışıyordur.

### Adım 6: Docker Desktop Ayarları

1. Docker Desktop menü çubuğundaki ikona tıklayın
2. **Settings** (⚙️) > **Resources** bölümüne gidin
3. **Advanced** sekmesinde:
   - **CPUs**: En az 2 (önerilen: 4+)
   - **Memory**: En az 4GB (önerilen: 8GB)
   - **Swap**: 1GB
   - **Disk image size**: En az 20GB (önerilen: 60GB)
4. **Apply & Restart** butonuna tıklayın

---

## Node.js Kurulumu

### Adım 1: Node.js İndirme

1. [Node.js resmi web sitesine](https://nodejs.org/) gidin
2. **LTS (Long Term Support)** versiyonunu indirin (20.x önerilir)
3. **Windows Installer (.msi)** dosyasını indirin (64-bit)

### Adım 2: Node.js Kurulumu

1. İndirilen `.msi` dosyasını çalıştırın
2. Kurulum sihirbazını takip edin:
   - **"Next"** butonlarına tıklayın
   - **"Add to PATH"** seçeneğinin işaretli olduğundan emin olun
   - **"Automatically install the necessary tools"** seçeneğini işaretleyin (opsiyonel)
3. Kurulum tamamlandığında **"Finish"** butonuna tıklayın

### Adım 3: Node.js Kurulumunu Doğrulama

**PowerShell** veya **Command Prompt**'u açın (yeni bir pencere açmanız gerekebilir) ve:

```powershell
node --version
```

Çıktı `v20.x.x` formatında olmalıdır.

```powershell
npm --version
```

Çıktı `10.x.x` formatında olmalıdır.

### Adım 4: npm Yapılandırması (Opsiyonel)

⚠️ **Önemli**: Eğer PowerShell'de `npm` komutunu çalıştırırken "running scripts is disabled" hatası alıyorsanız, önce [PowerShell Execution Policy](#problem-powershellde-komutlar-çalışmıyor) sorununu çözmeniz gerekir.

npm'in daha hızlı çalışması için:

```powershell
npm config set registry https://registry.npmjs.org/
```

---

## Git Kurulumu

### Adım 1: Git İndirme

1. [Git resmi web sitesine](https://git-scm.com/download/win) gidin
2. **"Download for Windows"** butonuna tıklayın
3. İndirme otomatik olarak başlar

### Adım 2: Git Kurulumu

1. İndirilen `.exe` dosyasını çalıştırın
2. Kurulum sihirbazını takip edin:
   - Varsayılan ayarları kabul edebilirsiniz
   - **"Git from the command line and also from 3rd-party software"** seçeneğini seçin
   - **"Use bundled OpenSSH"** seçeneğini seçin
   - **"Use the OpenSSL library"** seçeneğini seçin
   - **"Checkout Windows-style, commit Unix-style line endings"** seçeneğini seçin
   - **"Use MinTTY"** seçeneğini seçin
3. Kurulum tamamlandığında **"Finish"** butonuna tıklayın

### Adım 3: Git Kurulumunu Doğrulama

**PowerShell** veya **Command Prompt**'u açın ve:

```powershell
git --version
```

Çıktı şuna benzer olmalıdır:
```
git version 2.42.0.windows.2
```

### Adım 4: Git Yapılandırması

İlk kullanım için Git'i yapılandırın:

```powershell
git config --global user.name "Adınız Soyadınız"
git config --global user.email "email@example.com"
```

---

## Backend Kurulumu

### Adım 1: Proje Dizinine Gitme

PowerShell veya Command Prompt'u açın ve proje dizinine gidin:

```powershell
cd C:\Users\<KullanıcıAdınız>\Projects\collmind\collmind.backend
```

**Not**: Proje dizininiz farklı bir konumdaysa, o yolu kullanın.

### Adım 2: Node.js Versiyonunu Kontrol Etme

```powershell
node --version
```

Çıktı `v20.x.x` formatında olmalıdır. Eğer farklı bir versiyon varsa, yukarıdaki [Node.js Kurulumu](#nodejs-kurulumu) bölümüne bakın.

### Adım 3: Bağımlılıkları Yükleme

```powershell
npm install
```

Bu işlem birkaç dakika sürebilir. Tüm npm paketleri indirilir ve `node_modules` klasörü oluşturulur.

### Adım 4: Ortam Değişkenlerini Yapılandırma

Proje dizininde `.env` dosyası oluşturun:

**PowerShell ile:**
```powershell
Copy-Item .env.example .env
```

Eğer `.env.example` dosyası yoksa, aşağıdaki içeriği kullanarak `.env` dosyası oluşturun:

**Notepad ile:**
```powershell
notepad .env
```

Aşağıdaki içeriği yapıştırın:

```env
# Server Configuration
NODE_ENV=development
PORT=3000

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=collmind_tpm
DB_SCHEMA=main

# JWT Configuration
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRES_IN=1d
```

Dosyayı kaydedin ve kapatın.

⚠️ **Önemli**: Production ortamında `JWT_SECRET` değerini mutlaka güçlü bir değerle değiştirin!

### Adım 5: PostgreSQL'i Docker ile Başlatma

Proje dizininde (docker-compose.yml dosyasının bulunduğu yerde) aşağıdaki komutu çalıştırın:

```powershell
docker compose up -d postgres
```

Bu komut:
- PostgreSQL 16.x image'ını indirir (ilk seferinde)
- `collmind-tpm-postgres` adında bir container oluşturur
- PostgreSQL'i port 5432'de başlatır
- Veritabanı şemasını (`main`) otomatik olarak oluşturur

### Adım 6: PostgreSQL Container Durumunu Kontrol Etme

```powershell
docker compose ps
```

Çıktı şuna benzer olmalıdır:
```
NAME                        STATUS              PORTS
collmind-tpm-postgres       Up (healthy)        0.0.0.0:5432->5432/tcp
```

### Adım 7: Migration'ları Çalıştırma

Veritabanı şemasını oluşturmak için migration'ları çalıştırın:

```powershell
npm run migration:run
```

Bu komut:
- Tüm migration dosyalarını çalıştırır
- Veritabanı tablolarını oluşturur
- Gerekli indeksleri ve constraint'leri ekler

### Adım 8: Seed Verilerini Yükleme (Opsiyonel)

Test verilerini yüklemek için:

```powershell
npm run seed:run
```

Sadece temel verileri yükler. Tüm seed verilerini temizleyip yeniden yüklemek için:

```powershell
npm run seed:cleanup-and-seed
```

---

## Frontend Kurulumu

### Adım 1: Proje Dizinine Gitme

PowerShell veya Command Prompt'u açın ve frontend proje dizinine gidin:

```powershell
cd C:\Users\<KullanıcıAdınız>\Projects\collmind\collmind.frontend
```

### Adım 2: Node.js Versiyonunu Kontrol Etme

```powershell
node --version
```

Çıktı `v18.x.x` veya `v20.x.x` formatında olmalıdır.

### Adım 3: Bağımlılıkları Yükleme

```powershell
npm install
```

Bu işlem birkaç dakika sürebilir.

### Adım 4: Ortam Değişkenlerini Yapılandırma

Proje dizininde `.env` dosyası oluşturun:

**PowerShell ile:**
```powershell
Copy-Item env.example .env
```

**Notepad ile:**
```powershell
notepad .env
```

Aşağıdaki içeriği yapıştırın:

```env
# Backend API Base URL
# Local backend çalışıyorsa:
VITE_API_BASE_URL=http://localhost:3000

# Production backend kullanıyorsanız:
# VITE_API_BASE_URL=https://backend-315318338776.europe-west1.run.app

# Uygulama Bilgileri
VITE_APP_NAME=CollMind TPM
VITE_APP_VERSION=1.0.0
```

Dosyayı kaydedin ve kapatın.

**Önemli Notlar:**
- Vite'da ortam değişkenleri `VITE_` prefix'i ile başlamalıdır
- `.env` dosyasındaki değişiklikler için development server'ı yeniden başlatmanız gerekebilir

---

## Projeyi Çalıştırma

### Backend'i Çalıştırma

1. **PowerShell** veya **Command Prompt** açın
2. Backend proje dizinine gidin:
   ```powershell
   cd C:\Users\<KullanıcıAdınız>\Projects\collmind\collmind.backend
   ```
3. PostgreSQL'in çalıştığını kontrol edin:
   ```powershell
   docker compose ps postgres
   ```
4. Backend'i development modunda başlatın:
   ```powershell
   npm run start:dev
   ```

Backend başarıyla çalıştığında:
- API: `http://localhost:3000`
- Swagger: `http://localhost:3000/api`

### Frontend'i Çalıştırma

1. **Yeni bir PowerShell** veya **Command Prompt** penceresi açın
2. Frontend proje dizinine gidin:
   ```powershell
   cd C:\Users\<KullanıcıAdınız>\Projects\collmind\collmind.frontend
   ```
3. Frontend'i development modunda başlatın:
   ```powershell
   npm run dev
   ```

Frontend başarıyla çalıştığında:
- Uygulama: `http://localhost:5173`

Tarayıcıda `http://localhost:5173` adresine giderek uygulamayı görebilirsiniz.

---

## Sorun Giderme

### Docker ile İlgili Sorunlar

#### Problem: Docker Desktop başlamıyor

**Çözüm:**
1. Docker Desktop'ı tamamen kapatın (sistem tepsindeki ikona sağ tıklayıp "Quit Docker Desktop")
2. Windows'u yeniden başlatın
3. Docker Desktop'ı yeniden başlatın
4. Hala sorun varsa, Docker Desktop'ı yeniden yükleyin

#### Problem: WSL 2 kurulu değil

**Çözüm:**
1. PowerShell'i **Yönetici olarak** açın
2. Şu komutu çalıştırın:
   ```powershell
   wsl --install
   ```
3. Bilgisayarı yeniden başlatın
4. Docker Desktop'ı yeniden başlatın

#### Problem: Port 5432 zaten kullanılıyor

**Çözüm:**

Port'u kullanan process'i bulun:
```powershell
netstat -ano | findstr :5432
```

Process ID'yi (PID) not edin ve sonlandırın:
```powershell
taskkill /PID <PID> /F
```

Veya Docker Compose dosyasında farklı bir port kullanın (`docker-compose.yml`):
```yaml
ports:
  - '5433:5432'
```

Ve `.env` dosyasında da portu güncelleyin:
```env
DB_PORT=5433
```

#### Problem: PostgreSQL container'ı sağlıksız (unhealthy)

**Çözüm:**
```powershell
# Container loglarını kontrol edin
docker compose logs postgres

# Container'ı yeniden başlatın
docker compose restart postgres

# Hala sorun varsa, container'ı silip yeniden oluşturun
docker compose down
docker compose up -d postgres
```

### Node.js ile İlgili Sorunlar

#### Problem: "Command not found: node" veya "Command not found: npm"

**Çözüm:**
1. Node.js'in kurulu olduğunu kontrol edin: `where node`
2. Eğer kurulu değilse, [Node.js Kurulumu](#nodejs-kurulumu) bölümüne bakın
3. PowerShell veya Command Prompt'u **yeniden başlatın**
4. PATH değişkenini kontrol edin: `echo $env:PATH` (PowerShell) veya `echo %PATH%` (CMD)

#### Problem: "Cannot find module" hatası

**Çözüm:**
```powershell
# node_modules klasörünü silin
Remove-Item -Recurse -Force node_modules

# package-lock.json'u silin (opsiyonel)
Remove-Item package-lock.json

# Bağımlılıkları yeniden yükleyin
npm install
```

#### Problem: npm install çok yavaş veya takılı kalıyor

**Çözüm:**
1. İnternet bağlantınızı kontrol edin
2. npm cache'i temizleyin:
   ```powershell
   npm cache clean --force
   ```
3. npm registry'yi kontrol edin:
   ```powershell
   npm config get registry
   ```
4. Alternatif olarak yarn kullanın:
   ```powershell
   npm install -g yarn
   yarn install
   ```

### PostgreSQL ile İlgili Sorunlar

#### Problem: "Connection refused" hatası

**Çözüm:**

**Docker kullanıyorsanız:**
```powershell
# Container'ın çalıştığını kontrol edin
docker compose ps

# Container'ı başlatın
docker compose start postgres
```

#### Problem: "Database does not exist" hatası

**Çözüm:**

Veritabanını oluşturun:
```powershell
docker compose exec postgres psql -U postgres -c "CREATE DATABASE collmind_tpm;"
```

#### Problem: "Schema does not exist" hatası

**Çözüm:**

Şemayı oluşturun:
```powershell
docker compose exec postgres psql -U postgres -d collmind_tpm -c "CREATE SCHEMA IF NOT EXISTS main;"
```

### Backend ile İlgili Sorunlar

#### Problem: Migration çalışmıyor

**Çözüm:**
1. `.env` dosyasındaki veritabanı bilgilerini kontrol edin
2. PostgreSQL'in çalıştığını doğrulayın: `docker compose ps postgres`
3. Migration dosyalarının derlendiğinden emin olun:
   ```powershell
   npm run build:migrations
   ```

#### Problem: Port 3000 zaten kullanılıyor

**Çözüm:**

Port'u kullanan process'i bulun:
```powershell
netstat -ano | findstr :3000
```

Process'i sonlandırın:
```powershell
taskkill /PID <PID> /F
```

Veya `.env` dosyasında farklı bir port kullanın:
```env
PORT=3001
```

### Frontend ile İlgili Sorunlar

#### Problem: Port 5173 zaten kullanılıyor

**Çözüm:**

Port'u kullanan process'i bulun:
```powershell
netstat -ano | findstr :5173
```

Process'i sonlandırın:
```powershell
taskkill /PID <PID> /F
```

#### Problem: "Network Error" veya "CORS Error"

**Çözüm:**
1. Backend'in çalıştığını kontrol edin:
   ```powershell
   curl http://localhost:3000/health
   ```
   Veya tarayıcıda `http://localhost:3000/api` adresine gidin
2. `.env` dosyasındaki `VITE_API_BASE_URL` değerini kontrol edin
3. Backend'i yeniden başlatın

#### Problem: "Failed to resolve import" hatası

**Çözüm:**
1. Import path'lerini kontrol edin
2. `vite.config.ts` dosyasındaki alias ayarlarını kontrol edin
3. Development server'ı yeniden başlatın

### Genel Sorunlar

#### Problem: PowerShell'de komutlar çalışmıyor

**Çözüm:**
1. PowerShell execution policy'yi kontrol edin:
   ```powershell
   Get-ExecutionPolicy
   ```
2. Eğer "Restricted" ise, değiştirin:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

#### Problem: Dosya yollarında sorun

**Çözüm:**
- Windows'ta dosya yolları backslash (`\`) kullanır
- PowerShell'de hem backslash hem de forward slash (`/`) çalışır
- Command Prompt'ta sadece backslash çalışır

---

## Hızlı Başlangıç Özeti

Tüm kurulumu tek seferde yapmak için:

### Backend:

```powershell
# 1. Proje dizinine git
cd C:\Users\<KullanıcıAdınız>\Projects\collmind\collmind.backend

# 2. Bağımlılıkları yükle
npm install

# 3. .env dosyasını oluştur
notepad .env
# .env dosyasını düzenleyin (yukarıdaki örneğe göre)

# 4. PostgreSQL'i Docker ile başlat
docker compose up -d postgres

# 5. Migration'ları çalıştır
npm run migration:run

# 6. (Opsiyonel) Seed verilerini yükle
npm run seed:run

# 7. Projeyi başlat
npm run start:dev
```

### Frontend:

```powershell
# 1. Proje dizinine git
cd C:\Users\<KullanıcıAdınız>\Projects\collmind\collmind.frontend

# 2. Bağımlılıkları yükle
npm install

# 3. .env dosyasını oluştur
notepad .env
# .env dosyasını düzenleyin (yukarıdaki örneğe göre)

# 4. Development server'ı başlat
npm run dev
```

---

## Ek Kaynaklar

- [Docker Desktop Dokümantasyonu](https://docs.docker.com/desktop/)
- [WSL 2 Dokümantasyonu](https://docs.microsoft.com/en-us/windows/wsl/)
- [Node.js Dokümantasyonu](https://nodejs.org/docs/)
- [PostgreSQL Dokümantasyonu](https://www.postgresql.org/docs/)
- [NestJS Dokümantasyonu](https://docs.nestjs.com/)
- [Vite Dokümantasyonu](https://vitejs.dev/)
- [React Dokümantasyonu](https://react.dev/)

---

## Destek

Sorun yaşarsanız:
1. Bu dokümantasyondaki [Sorun Giderme](#sorun-giderme) bölümüne bakın
2. Proje README.md dosyalarını kontrol edin
3. Docker ve PostgreSQL loglarını inceleyin
4. Geliştirme ekibiyle iletişime geçin

---

**Son Güncelleme**: 2024
