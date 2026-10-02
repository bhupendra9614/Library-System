package com.bhupi.config;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import com.bhupi.entity.Book;
import com.bhupi.repository.BookRepository;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

/**
 * Start hote hi 60 tech/fiction books add karta hai (Programming 12, Fiction 10, Algorithms 10, Networking 8, Software Design 10, Software Engineering 10). Books turant aa jati hain (placeholder ISBN ke saath),
 * phir background me Open Library se har book ka ASLI ISBN laakar update karta hai,
 * taaki explore page par asli cover image aaye. (Server par internet chahiye.)
 * Band karne ke liye application.properties me likho: library.seed.tech=false
 */
@Component
@ConditionalOnProperty(name = "library.seed.tech", havingValue = "true", matchIfMissing = true)
public class TechBookDataSeeder implements CommandLineRunner {

    private final BookRepository bookRepository;
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(8))
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    public TechBookDataSeeder(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    // Columns: Book Title | Author | ISBN (placeholder, asli ISBN auto aayega) | Category | Price | Availability
    // Price: 55 books ke alag-alag, sirf 5 books ka same (399). Not Available: 9 books.
    private static final String[][] DATA = {
        // ---- Programming ----
        {"The C Programming Language", "Brian W. Kernighan and Dennis M. Ritchie", "SEED-T001", "Programming", "501", "Available"},
        {"Code Complete", "Steve McConnell", "SEED-T002", "Programming", "424", "Available"},
        {"Python Crash Course", "Eric Matthes", "SEED-T003", "Programming", "281", "Available"},
        {"Automate the Boring Stuff with Python", "Al Sweigart", "SEED-T004", "Programming", "399", "Available"},
        {"JavaScript: The Good Parts", "Douglas Crockford", "SEED-T005", "Programming", "402", "Available"},
        {"Eloquent JavaScript", "Marijn Haverbeke", "SEED-T006", "Programming", "677", "Available"},
        {"You Don't Know JS Yet", "Kyle Simpson", "SEED-T007", "Programming", "479", "Available"},
        {"Learning Python", "Mark Lutz", "SEED-T008", "Programming", "160", "Available"},
        {"C++ Primer", "Stanley B. Lippman", "SEED-T009", "Programming", "545", "Available"},
        {"The Rust Programming Language", "Steve Klabnik and Carol Nichols", "SEED-T010", "Programming", "556", "Available"},
        {"Fluent Python", "Luciano Ramalho", "SEED-T011", "Programming", "391", "Available"},
        {"Programming Pearls", "Jon Bentley", "SEED-T012", "Programming", "721", "Available"},
        // ---- Fiction ----
        {"The Kite Runner", "Khaled Hosseini", "SEED-T013", "Fiction", "270", "Available"},
        {"To Kill a Mockingbird", "Harper Lee", "SEED-T014", "Fiction", "248", "Available"},
        {"The Great Gatsby", "F. Scott Fitzgerald", "SEED-T015", "Fiction", "336", "Available"},
        {"The Catcher in the Rye", "J.D. Salinger", "SEED-T016", "Fiction", "732", "Available"},
        {"One Hundred Years of Solitude", "Gabriel Garcia Marquez", "SEED-T017", "Fiction", "523", "Available"},
        {"The Book Thief", "Markus Zusak", "SEED-T018", "Fiction", "399", "Available"},
        {"Life of Pi", "Yann Martel", "SEED-T019", "Fiction", "369", "Available"},
        {"The God of Small Things", "Arundhati Roy", "SEED-T020", "Fiction", "622", "Available"},
        {"The Old Man and the Sea", "Ernest Hemingway", "SEED-T021", "Fiction", "743", "Not Available"},
        {"Of Mice and Men", "John Steinbeck", "SEED-T022", "Fiction", "655", "Available"},
        // ---- Algorithms ----
        {"Algorithms, 4th Edition", "Robert Sedgewick and Kevin Wayne", "SEED-T023", "Algorithms", "347", "Available"},
        {"The Algorithm Design Manual", "Steven S. Skiena", "SEED-T024", "Algorithms", "666", "Available"},
        {"Algorithm Design", "Jon Kleinberg and Eva Tardos", "SEED-T025", "Algorithms", "633", "Available"},
        {"Grokking Algorithms", "Aditya Bhargava", "SEED-T026", "Algorithms", "688", "Available"},
        {"The Art of Computer Programming, Volume 1", "Donald E. Knuth", "SEED-T027", "Algorithms", "292", "Available"},
        {"Cracking the Coding Interview", "Gayle Laakmann McDowell", "SEED-T028", "Algorithms", "578", "Not Available"},
        {"Data Structures and Algorithm Analysis in Java", "Mark Allen Weiss", "SEED-T029", "Algorithms", "468", "Available"},
        {"Competitive Programming 4", "Steven Halim", "SEED-T030", "Algorithms", "399", "Not Available"},
        {"Algorithms Unlocked", "Thomas H. Cormen", "SEED-T031", "Algorithms", "171", "Available"},
        {"Elements of Programming Interviews", "Adnan Aziz, Tsung-Hsien Lee and Amit Prakash", "SEED-T032", "Algorithms", "358", "Not Available"},
        // ---- Networking ----
        {"Computer Networking: A Top-Down Approach", "James F. Kurose and Keith W. Ross", "SEED-T033", "Networking", "490", "Available"},
        {"Computer Networks", "Andrew S. Tanenbaum", "SEED-T034", "Networking", "754", "Available"},
        {"TCP/IP Illustrated, Volume 1", "W. Richard Stevens", "SEED-T035", "Networking", "314", "Not Available"},
        {"Data Communications and Networking", "Behrouz A. Forouzan", "SEED-T036", "Networking", "237", "Available"},
        {"Computer Networks: A Systems Approach", "Larry L. Peterson and Bruce S. Davie", "SEED-T037", "Networking", "644", "Available"},
        {"Unix Network Programming", "W. Richard Stevens", "SEED-T038", "Networking", "589", "Not Available"},
        {"High Performance Browser Networking", "Ilya Grigorik", "SEED-T039", "Networking", "600", "Available"},
        {"Network Warrior", "Gary A. Donahue", "SEED-T040", "Networking", "325", "Available"},
        // ---- Software Design ----
        {"Domain-Driven Design", "Eric Evans", "SEED-T041", "Software Design", "699", "Available"},
        {"Head First Design Patterns", "Eric Freeman and Elisabeth Robson", "SEED-T042", "Software Design", "399", "Available"},
        {"A Philosophy of Software Design", "John Ousterhout", "SEED-T043", "Software Design", "446", "Available"},
        {"Clean Architecture", "Robert C. Martin", "SEED-T044", "Software Design", "457", "Not Available"},
        {"Patterns of Enterprise Application Architecture", "Martin Fowler", "SEED-T045", "Software Design", "215", "Available"},
        {"Designing Data-Intensive Applications", "Martin Kleppmann", "SEED-T046", "Software Design", "182", "Available"},
        {"Fundamentals of Software Architecture", "Mark Richards and Neal Ford", "SEED-T047", "Software Design", "303", "Available"},
        {"Building Microservices", "Sam Newman", "SEED-T048", "Software Design", "512", "Available"},
        {"Implementing Domain-Driven Design", "Vaughn Vernon", "SEED-T049", "Software Design", "710", "Available"},
        {"Software Architecture in Practice", "Len Bass, Paul Clements and Rick Kazman", "SEED-T050", "Software Design", "567", "Not Available"},
        // ---- Software Engineering ----
        {"The Mythical Man-Month", "Frederick P. Brooks Jr.", "SEED-T051", "Software Engineering", "413", "Available"},
        {"Software Engineering", "Ian Sommerville", "SEED-T052", "Software Engineering", "226", "Available"},
        {"Peopleware", "Tom DeMarco and Timothy Lister", "SEED-T053", "Software Engineering", "534", "Available"},
        {"The Phoenix Project", "Gene Kim, Kevin Behr and George Spafford", "SEED-T054", "Software Engineering", "204", "Not Available"},
        {"Continuous Delivery", "Jez Humble and David Farley", "SEED-T055", "Software Engineering", "193", "Available"},
        {"Accelerate", "Nicole Forsgren, Jez Humble and Gene Kim", "SEED-T056", "Software Engineering", "399", "Available"},
        {"Software Engineering at Google", "Titus Winters, Tom Manshreck and Hyrum Wright", "SEED-T057", "Software Engineering", "611", "Available"},
        {"Software Engineering: A Practitioner's Approach", "Roger S. Pressman", "SEED-T058", "Software Engineering", "435", "Available"},
        {"Working Effectively with Legacy Code", "Michael Feathers", "SEED-T059", "Software Engineering", "259", "Available"},
        {"Extreme Programming Explained", "Kent Beck", "SEED-T060", "Software Engineering", "380", "Available"}
    };

    @Override
    public void run(String... args) {
        Map<String, Book> existing = new HashMap<>();
        for (Book b : bookRepository.findAll()) {
            existing.put(b.getTitle().toLowerCase(), b);
        }

        List<Book> toSave = new ArrayList<>();
        List<Book> needIsbn = new ArrayList<>();
        for (String[] row : DATA) {
            Book old = existing.get(row[0].toLowerCase());
            if (old != null) {
                if (old.getIsbn() != null && old.getIsbn().startsWith("SEED-")) {
                    needIsbn.add(old);          // pehle se hai par abhi placeholder ISBN hai
                }
                continue;
            }
            Book b = new Book();
            b.setTitle(row[0]);
            b.setAuthor(row[1]);
            b.setIsbn(row[2]);
            b.setCategory(row[3]);
            b.setPrice(Double.parseDouble(row[4]));
            b.setAvailable("Available".equalsIgnoreCase(row[5]));
            toSave.add(b);
        }

        if (!toSave.isEmpty()) {
            needIsbn.addAll(bookRepository.saveAll(toSave));
            System.out.println("TechBookDataSeeder: " + toSave.size() + " books added.");
        }
        if (!needIsbn.isEmpty()) {
            fetchRealIsbns(needIsbn);
        }
    }

    /** Background me asli ISBN laata hai, app start ko nahi rokta. */
    private void fetchRealIsbns(List<Book> books) {
        ExecutorService pool = Executors.newFixedThreadPool(4);
        for (Book b : books) {
            Long id = b.getId();
            String title = b.getTitle();
            String author = b.getAuthor();
            pool.submit(() -> {
                String isbn = findRealIsbn(title, author);
                if (isbn != null) {
                    bookRepository.findById(id).ifPresent(fresh -> {
                        fresh.setIsbn(isbn);
                        bookRepository.save(fresh);
                    });
                }
            });
        }
        pool.shutdown();
        System.out.println("TechBookDataSeeder: asli ISBN background me update ho rahe hain...");
    }

    private String findRealIsbn(String title, String author) {
        try {
            String url = "https://openlibrary.org/search.json?title=" + enc(title)
                    + "&author=" + enc(author) + "&limit=1&fields=cover_edition_key,isbn";
            JsonNode root = getJson(url);
            if (root == null) return null;
            JsonNode docs = root.path("docs");
            if (!docs.isArray() || docs.size() == 0) return null;
            JsonNode doc = docs.get(0);

            // 1) jis edition ka cover hai, usi ka ISBN lo
            String olid = doc.path("cover_edition_key").asText("");
            if (!olid.isEmpty()) {
                JsonNode ed = getJson("https://openlibrary.org/books/" + olid + ".json");
                if (ed != null) {
                    String isbn = first(ed.path("isbn_13"));
                    if (isbn == null) isbn = first(ed.path("isbn_10"));
                    if (isbn != null) return isbn;
                }
            }
            // 2) nahi mila to search result ka pehla ISBN
            return first(doc.path("isbn"));
        } catch (Exception e) {
            return null;    // internet na ho to placeholder ISBN hi rehne do
        }
    }

    private JsonNode getJson(String url) throws Exception {
        HttpRequest req = HttpRequest.newBuilder(URI.create(url))
                .timeout(Duration.ofSeconds(12))
                .header("User-Agent", "LibraryProject/1.0")
                .GET().build();
        HttpResponse<String> res = HTTP.send(req, HttpResponse.BodyHandlers.ofString());
        return res.statusCode() == 200 ? MAPPER.readTree(res.body()) : null;
    }

    private static String first(JsonNode arr) {
        if (arr.isArray() && arr.size() > 0) {
            String v = arr.get(0).asText("").replace("-", "").trim();
            return v.isEmpty() || v.length() > 20 ? null : v;
        }
        return null;
    }

    private static String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}