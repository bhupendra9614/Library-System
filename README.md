# Library Management System

A web app to browse, issue and return library books. Built with Spring Boot, JSP and Oracle, with separate member and admin roles.

## Features

**Members**
- Register with name and 10-digit mobile number, then log in
- Explore books on category shelves with sliders and real cover images (via ISBN)
- View book details in a popup, search by title or author
- Add several books to a cart and pay once (demo payment: UPI, Card or Net Banking)
- "My Shelf" page: books being read, days left, fines, and return history

**Admin**
- Add, edit, delete and manage books
- See every issue and return record with member details
- Books with issue history cannot be deleted

**Rules**
- Loan period: 14 days
- Maximum 3 active books per member
- Issue fee: Rs 20 per book
- Late fine: Rs 5 per day
- A book can be issued again after it is returned

## Tech stack

Java 17+, Spring Boot 3, Spring MVC, Spring Security, Spring Data JPA (Hibernate), JSP + JSTL, Oracle Database, Maven

## Getting started

### 1. Requirements
- JDK 17 or newer
- Maven
- Oracle Database (XE is fine)

### 2. Configure the database
Copy the settings from `application.properties.example` into `src/main/resources/application.properties`, then set your credentials as environment variables:

```
DB_USER=your_oracle_username
DB_PASS=your_oracle_password
DB_URL=jdbc:oracle:thin:@localhost:1521:xe   # optional, this is the default
```

Windows (Command Prompt):
```
set DB_USER=your_oracle_username
set DB_PASS=your_oracle_password
```

### 3. Run
```
mvn spring-boot:run
```
Open http://localhost:8080

Hibernate creates the tables on first run.

### 4. Sample data
On startup the app adds sample books (about 160 titles across many categories). The ISBN of each book is fetched from Open Library in the background, so covers appear after a minute or two (internet needed). Turn this off after the first run:

```
library.seed=false
library.seed.tech=false
```

## Main pages

| URL | Who | What |
|---|---|---|
| `/` | everyone logged in | Home |
| `/explore` | members, admin | Category shelves, View, Add to Cart |
| `/books/search` | members, admin | Search by title or author |
| `/cart` | members, admin | Cart and payment |
| `/issues/my` | members | My Shelf |
| `/issues/all` | admin | All issues |
| `/books/add`, `/books/manage` | admin | Book management |

## Notes

- Payment is a **demo**. No real money is charged, and card, UPI or bank details are never sent to the server or stored. Only the payment method and a transaction ID are saved.
- Never commit real database passwords. Use environment variables as shown above.

## Screenshots

_Add screenshots of Home, Explore, Cart and My Shelf here._

## License

Add a license of your choice (for example MIT).
