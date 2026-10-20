# shopsphere: RTU Advanced Java Viva & Practical Defense Guide

This guide prepares students for the final university practical examination and viva voce for the **RTU Advanced Java / Java Enterprise** curriculum.

---

## 1. Syllabus Topic-to-Implementation Map

| RTU Syllabus Topic | Project Submodule / Package | Key Classes & Demonstration Files |
|---|---|---|
| **Swing & Swing MVC** | `shopsphere-swing-admin` | `MainSwingAdmin.java`, `LoginFrame.java`, `AdminDashboardFrame.java`, `ProductTableModel.java` |
| **Pluggable Look & Feel** | `shopsphere-swing-admin` | `UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName())` |
| **JDBC / PreparedStatement** | `shopsphere-dao` | `DBConnectionPool.java` (HikariCP), `UserDAO.java`, `ProductDAO.java`, `OrderDAO.java` |
| **java.net Socket Programming** | `shopsphere-network` | `InventoryServer.java` (ServerSocket), `InventoryClient.java` (Socket) |
| **Object Serialization** | `shopsphere-common` & `network` | `Product.java implements Serializable`, `NetworkCommand`, `ObjectOutputStream` / `ObjectInputStream` |
| **RMI & RMI Registry** | `shopsphere-rmi` | `InventoryRemoteService.java` (extends Remote), `InventoryRemoteServiceImpl.java`, `RmiServerLauncher.java` |
| **J2EE / N-Tier Architecture** | Complete Project | Presentation (JSP) &rarr; Controller (Servlet) &rarr; Service &rarr; DAO &rarr; MySQL |
| **Web Containers & Servlets** | `shopsphere-web` | Apache Tomcat 10.1, `HomeServlet`, `ProductServlet`, `CartServlet`, `CheckoutServlet` |
| **Servlet Lifecycle & Config** | `shopsphere-web` | `init()`, `service()`, `doGet()`, `doPost()`, `destroy()`, `ServletConfig`, `ServletContext` |
| **HTTP Sessions & Cookies** | `shopsphere-web` | `request.getSession()`, `session.setAttribute("user", ...)`, `shopsphere_recent` cookie |
| **Listeners & Event Handling**| `shopsphere-web` | `AppContextListener` (`ServletContextListener`), `AppSessionListener` (`HttpSessionListener`) |
| **Filters & Interception** | `shopsphere-web` | `AuthenticationFilter.java` (Protected Customer routes), `AdminFilter.java` (`/admin/*`) |
| **Traditional JSP Syntax** | `shopsphere-web` | `/syllabus/traditional-jsp.jsp` (`<%!...%>`, `<%...%>`, `<%=...%>`, `<%--...--%>`) |
| **Expression Language (EL)** | `shopsphere-web` | `${product.name}`, `${product.price}`, `${sessionScope.user.name}` |
| **Tag Extensions & Tag Files** | `shopsphere-web` | `/WEB-INF/tags/productCard.tag`, `/WEB-INF/tags/rating.tag` |
| **JSTL Core & Functions** | `shopsphere-web` | `<c:forEach>`, `<c:if>`, `<c:choose>`, `<c:set>` |
| **JSTL XML** | `shopsphere-web` | `/syllabus/jstl-xml.jsp` parsing product catalog feed |
| **JSTL SQL Contrast** | `shopsphere-web` | `/syllabus/jstl-sql.jsp` explaining why N-tier DAO replaces raw JSTL SQL |
| **Internationalization (i18n)**| `shopsphere-web` | `messages_en.properties`, `messages_hi.properties`, `ResourceBundle`, `Locale`, `NumberFormat` |
| **Naming and JNDI** | `shopsphere-web` | `/syllabus/jndi-demo.jsp` (`java:comp/env/jdbc/shopsphereDS` lookup) |

---

## 2. Top Viva Questions & Answers

### Q1: What is the difference between JSTL SQL and the DAO Layer?
> **Answer:** JSTL SQL tags (`<sql:query>`) embed raw SQL statements directly inside JSP presentation views. This violates the MVC design pattern, makes database credentials vulnerable in templates, and eliminates the possibility of unit testing.  
> In contrast, our production application uses an **N-Tier DAO Architecture**: The JSP view only interacts with Java models via Expression Language (`${product.name}`), the Servlet handles requests, the Service layer applies business rules, and the DAO layer interacts with MySQL using `PreparedStatement` on a **HikariCP** connection pool.

### Q2: How does the Servlet Lifecycle work?
> **Answer:** When an HTTP request targets a servlet:
> 1. **Loading & Instantiation:** Tomcat loads the bytecode and instantiates the servlet.
> 2. **Initialization (`init`):** Executed exactly once to load resources or `ServletConfig`.
> 3. **Request Servicing (`service`):** For each incoming request, the container spawns a worker thread that invokes `service(HttpServletRequest, HttpServletResponse)`, which dispatches to `doGet()` or `doPost()`.
> 4. **Destruction (`destroy`):** Executed once when the container unloads the web application.

### Q3: Explain how Java RMI differs from Socket Programming.
> **Answer:**
> - **Socket Programming (`java.net`):** Low-level communication across TCP sockets. The developer is responsible for defining the protocol, opening streams, framing packets, and parsing byte streams.
> - **Java RMI (Remote Method Invocation):** High-level object-oriented distributed computing. A client invokes a method on a local stub as if it were a local Java object. The RMI runtime handles marshalling parameters, remote transport over TCP, unmarshalling, and returning serialized results transparently.

### Q4: Why is Object Serialization necessary in our project?
> **Answer:** In Java, objects reside in JVM memory as references. To transmit a `Product` or `Order` object over a network socket or an RMI boundary, the object state must be serialized (flattened into a portable byte stream) via `ObjectOutputStream`. The receiving JVM uses `ObjectInputStream` to reconstruct an identical instance. In shopsphere, domain models implement `java.io.Serializable` with a explicit `serialVersionUID`.

### Q5: How do Filters protect customer and admin resources?
> **Answer:** Filters intercept requests before they reach the servlet controller:
> - `AuthenticationFilter` checks if `session.getAttribute("user") != null`. If unauthenticated, it redirects the visitor to `/login` and saves the requested URI for post-login return.
> - `AdminFilter` inspects `/admin/*` requests to confirm `user.isAdmin()`. If not an admin, it halts execution with HTTP 403 Forbidden.

