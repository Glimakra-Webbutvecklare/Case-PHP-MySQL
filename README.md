# Case Fullstack PHP

I det här caset bygger du en full‑stack‑applikation där inloggade användare kan skapa, läsa, uppdatera och ta bort (CRUD) en valfri typ av resurs. Vilken resurs det är bestämmer du själv – t.ex. en receptbok, kontaktbok, diktsamling, twitterklon, fotodagbok … välj något som känns roligt och rimligt att färdigställa inom tidsramen.

Språken du ska använda är PHP, SQL, HTML, CSS och JavaScript.

Dockermiljö och casebeskrivning för att utveckla en fullstackapplikation. Du kan välja mellan **två spår**:

- **Spår A – Vanilla PHP:** PHP utan ramverk, PDO, manuell sessionshantering
- **Spår B – Laravel:** Laravel med Blade, Eloquent, Breeze

Kraven skiljer sig mellan spåren — se respektive avsnitt nedan. Välj det spår som passar dig bäst och meddela läraren vilket du valt.

---

## Förutsättningar

Docker Desktop ska vara installerat och startat: https://www.docker.com/

### Spår A – Vanilla PHP

| Område | Krav |
|---|---|
| Språk | PHP, JavaScript, HTML, CSS |
| CSS-ramverk | SCSS |
| Databas | MySQL/MariaDB med PDO |
| Webbserver | Apache (ingår i Docker-imagen) |
| Tabeller | Minst 2 st |
| Applikation | Valfri domän (förslag: sidhanterare / CMS) |

### Spår B – Laravel

| Område | Krav |
|---|---|
| Ramverk | Laravel 11+ |
| CSS-ramverk | SCSS |
| Databas | MySQL/MariaDB med Eloquent ORM |
| Webbserver | Apache (ingår i Docker-imagen) |
| Tabeller | Minst 3 st (utnyttja Eloquent-relationer) |
| Applikation | Valfri domän (förslag: sidhanterare / CMS) |

---

## Grundläggande krav

### Gemensamma krav (gäller båda spår)

- **Publik vy:** Besökare kan läsa publicerat innehåll utan inloggning
- **Registrering:** Besökare kan registrera konto (användarnamn + lösenord, hashat)
- **Inloggning/utloggning:** Sessionsbaserad autentisering
- **CRUD:** Inloggad användare kan skapa, läsa, redigera och ta bort **sina egna** resurser
- **Filuppladdning:** Inloggad användare kan ladda upp och bifoga bilder/filer till sina resurser
- **Docker:** Applikationen körs i en Docker-miljö
- **Navigation:** En aside-meny för navigation mellan applikationens delar
- **Git/GitHub:** Minst 10 commits med beskrivande meddelanden, `README.md` som dokumenterar projektet
- **Databas:** Tabeller skapas automatiskt vid setup (vanilla: skript, Laravel: migrations)

> **För spår B gäller dessutom:** Du ska lösa ovanstående krav **med ramverkets inbyggda funktioner**, inte genom manuella lösningar (se nästa avsnitt).

### Spår A – Specifika krav (Vanilla PHP)

- Manuell databasanslutning med PDO och config-fil
- Handskriven autentisering (`register.php`, `login.php`, `logout.php`)
- Manuell sessionskontroll (`$_SESSION`) i varje skyddad fil
- Prepared statements för alla SQL-frågor
- `htmlspecialchars()` på all användargenererad output
- Manuell filuppladdning (`$_FILES` + `move_uploaded_file()`)
- Manuell validering (`filter_input()` / `filter_var()`)
- Manuella redirects (`header('Location: ...')`)

### Spår B – Specifika krav (Laravel)

> Dessa krav **ersätter** motsvarande manuella lösningar i spår A.

| Område | Krav |
|---|---|
| Autentisering | Använd Laravel Breeze (rekommenderas) eller manuell auth via `Auth`-facaden |
| Databas | Eloquent-modeller med relationer (`hasMany`, `belongsTo`) |
| Vyer | Blade med layout inheritance (`@extends`, `@section`, `@yield`) |
| Validering | `$request->validate()` i kontrollern |
| Filuppladdning | Laravel Storage (`$request->file()->store()`) + `php artisan storage:link` |
| CSRF-skydd | `@csrf` i alla formulär |
| Routing | `Route::middleware('auth')`-grupper för skyddade routes |
| Auktorisering | Policies för ägarskapskontroll (t.ex. `$this->authorize('update', $page)`) |
| Databasschema | Migrations (`php artisan migrate`) |
| Route-navigering | Named routes + `route()`-hjälpfunktion |
| Route model binding | `Page $page` i kontrollern istället för manuell ID-hämtning |
| Flash-meddelanden | `->with('success', 'Meddelande')` vid redirect |
| Resurser | Minst 2 st — t.ex Recepies och Comments |

---

## Designkrav (gäller båda spår)

- En **administrativ dashboard** ska implementeras med en **separat SCSS-fil**
- Dashboardens design ska vara **tydligt åtskild** från den publika delen av applikationen
- Exempel: mörkare färgschema, annan layout, tydlig visuell gräns mellan admin och publik vy

| Spår | Implementation |
|---|---|
| Spår A | Skapa en separat SCSS/CSS-fil som laddas in på admin-sidorna. Organisera admin-filerna i en egen mapp (t.ex. `admin/`) |
| Spår B | Skapa en separat Blade layout för admin (`layouts/admin.blade.php`) med en egen SCSS-fil. Använd `@vite` eller manuell inkludering |

---

## Utmaningar

### Spår A – Vanilla PHP

- Media queries / responsiv design för mobil och desktop
- Extra fält: `email` på user, `updated_at` på resurs, `published`-flagga, `alt`-text på bild
- WYSIWYG-editor (TinyMCE eller CKEditor) för textinnehåll
- Snygga URLs via `.htaccess` (mod_rewrite)
- Publicera på webbhotell (t.ex. Hetzner eller DigitalOcean)

### Spår B – Laravel

- Implementera **Form Request-klasser** för validering istället för inline `$request->validate()`
- Skapa en **Database Seeder** för att populera databasen med exempeldata
- Lägg till **draft/published-status** och använd **Eloquent Scopes** (t.ex. `->published()`)
- Implementera **paginering** (`->paginate()`) på resurslistning
- Bygg en **sökfunktion** med Eloquent query scopes
- Ladda upp och hantera **flera bilder per resurs** (om du inte redan gjort det)
- Publicera på webbhotell (t.ex. Laravel Forge, Hetzner eller DigitalOcean)

---

## Feedback / Bedömning

| Rubrik | Tillräckligt | Väl godkänt |
|---|---|---|
| Funktionella krav | Alla grundläggande krav är implementerade | Utöver G: 3+ utmaningar är implementerade |
| Kodkvalitet | Konsekvent indentering, engelska variabelnamn, kommentarer | Mycket välstrukturerad kod, DRY, separation of concerns |
| Databas | Tabeller skapas automatiskt, följer normalform | Välmotiverad struktur med rätt relationer och index |
| Versionshantering | Minst 10 commits med vettiga meddelanden | Commits är små, logiska och väl beskrivna |
| Dokumentation | `README.md` finns och beskriver projektet | Utförlig README med setup-instruktioner, skärmdumpar och tekniska val |
| Design | Grundläggande layout med CSS-ramverk fungerar | Responsiv design, genomtänkt UX |

---

## Presentation och inlämning

- 18de maj kl 08.45 halvtidsredovisning
- 25de maj kl 08.45 slutsredovisning
- Koden publiceras på GitHub (privat repository) och delas med Anders, Henry och Mattias

---

## Kom igång – Spår A (Vanilla PHP)

1. Klona ner repot
2. Skapa en `.env`-fil i rotmappen (se avsnittet Miljövariabler nedan)
3. Öppna terminalen och ange: `docker-compose up`
4. När applikationen startat, öppna http://localhost:8050
5. Du ska nu se "Hello world"

### MySQL via phpMyAdmin (spår A)

- Öppna http://localhost:8051
- Logga in med:
  - Server: `mysql`
  - Användarnamn: `db_user`
  - Lösenord: `db_password`
- Databasen `db_template` är tillgänglig

---

## Kom igång – Spår B (Laravel)

1. Klona ner repot
2. Skapa en `.env`-fil i rotmappen (se avsnittet Miljövariabler nedan)
3. Se till att PHP och composer är installerat
   Windows:
   ```
   winget download php8.4 --skip-dependencies -d .
   winget install PHP.PHP.8.4
   # Installera composer, ladda ner och kör https://getcomposer.org/Composer-Setup.exe
   ```
5. Öppna terminalen i mappen `laravel/` och kör:
   ```bash
   docker-compose up -d
   ```
6. Skapa ett nytt Laravel-projekt i `app/`-mappen:
   ```bash
   composer create-project laravel/laravel .
   ```
7. Konfigurera Laravels `.env` (inuti `app/`):
   ```
   DB_CONNECTION=mysql
   DB_HOST=mysql
   DB_PORT=3306
   DB_DATABASE=db_template
   DB_USERNAME=db_user
   DB_PASSWORD=db_password
   ```
8. Öppna http://localhost:8060 — du ska nu se Laravels välkomstsida

### MySQL via phpMyAdmin (spår B)

- Öppna http://localhost:8061
- Logga in med:
  - Server: `mysql`
  - Användarnamn: `db_user`
  - Lösenord: `db_password`

---

## Miljövariabler

Gör en kopia av `.env-example` och namnge den till `.env`. Här lägger du uppgifter för din miljö — databasnamn, användare, lösenord, etc.

Filen `.env` versionshanteras **inte** — den finns redan i `.gitignore`.

**.env-example:**
```
LOCAL_PORT=8050
MYSQL_ROOT_PASSWORD=db_root_password
MYSQL_USER=db_user
MYSQL_PASSWORD=db_password
MYSQL_DATABASE=db_template
```

> För spår B: skapa en `.env`-fil även i mappen `laravel/`. Använd `LOCAL_PORT=8060` för att undvika port-konflikter med spår A.

---

## Applikationens tabeller

Applikationen bygger på följande tabeller (exempel för en sidhanterare). Du får välja en annan domän, men antalet tabeller måste följa kraven för ditt spår.

| Spår | Minsta antal tabeller |
|---|---|
| Spår A – Vanilla PHP | 2 (Users, Resource1) |
| Spår B – Laravel | 3 (Users, Resource1, Resource2)|


> **Spår A:** Tabellerna skapas automatiskt vid första körning via ett PHP-skript _setup.php (`CREATE TABLE IF NOT EXISTS`).
>
> **Spår B:** Använd Laravels migrations för att skapa tabellerna. Kör `php artisan migrate` för att skapa dem. Laravel Breeze kan användas för `users`-tabellen — då slipper du skapa den själv.

---

## Applikationens olika delar (exempel för sidhanterare)

Applikationen kan delas in i följande vyer. Anpassa efter din valda domän.

### Navigation
En aside-meny som innehåller:
- Länk till startsidan (publik)
- Om inloggad: länk till admin/dashboard
- Om inloggad: länk för att skapa ny resurs
- Inloggning/registrering (om utloggad) eller utloggning (om inloggad)

### Publika sidor
- Startsida: listar allt publicerat innehåll
- Detaljsida: visar en enskild resurs med tillhörande bilder

### Admin / Dashboard
- **Separat design** med egen SCSS-fil
- Tydligt visuellt avgränsad från publika sidor
- Översikt över inloggad användares resurser
- Möjlighet att skapa ny, redigera och ta bort

### Autentisering
- Registreringsformulär
- Inloggningsformulär
- Utloggningslänk
