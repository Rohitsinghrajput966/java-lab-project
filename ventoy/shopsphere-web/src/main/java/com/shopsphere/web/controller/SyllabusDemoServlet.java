package com.shopsphere.web.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;

@WebServlet(name = "SyllabusDemoServlet", urlPatterns = {
        "/syllabus",
        "/syllabus/traditional-jsp",
        "/syllabus/jstl-xml",
        "/syllabus/jstl-sql",
        "/syllabus/i18n",
        "/syllabus/jndi",
        "/syllabus/url-connection"
})
public class SyllabusDemoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path == null || path.equals("/syllabus")) {
            path = "/syllabus/index";
        }

        switch (path) {
            case "/syllabus/traditional-jsp":
                request.setAttribute("demoStudentName", "Aditya Sharma");
                request.setAttribute("demoUniversity", "Rajasthan Technical University (RTU)");
                request.getRequestDispatcher("/syllabus/traditional-jsp.jsp").forward(request, response);
                break;

            case "/syllabus/jstl-xml":
                String sampleXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                        "<catalog>\n" +
                        "  <product id=\"101\">\n" +
                        "    <name>ProSound Wireless Headphones</name>\n" +
                        "    <category>Electronics</category>\n" +
                        "    <price>199.99</price>\n" +
                        "    <stock>45</stock>\n" +
                        "  </product>\n" +
                        "  <product id=\"102\">\n" +
                        "    <name>UltraBook Pro 15.6 Retina</name>\n" +
                        "    <category>Electronics</category>\n" +
                        "    <price>1249.00</price>\n" +
                        "    <stock>20</stock>\n" +
                        "  </product>\n" +
                        "  <product id=\"103\">\n" +
                        "    <name>Classic Tailored Oxford Shirt</name>\n" +
                        "    <category>Fashion</category>\n" +
                        "    <price>45.00</price>\n" +
                        "    <stock>85</stock>\n" +
                        "  </product>\n" +
                        "</catalog>";
                request.setAttribute("xmlProductFeed", sampleXml);
                request.getRequestDispatcher("/syllabus/jstl-xml.jsp").forward(request, response);
                break;

            case "/syllabus/jstl-sql":
                request.getRequestDispatcher("/syllabus/jstl-sql.jsp").forward(request, response);
                break;

            case "/syllabus/i18n":
                String lang = request.getParameter("lang");
                Locale currentLocale = "hi".equalsIgnoreCase(lang) ? new Locale("hi", "IN") : Locale.US;

                ResourceBundle bundle = ResourceBundle.getBundle("messages", currentLocale);
                request.setAttribute("bundle", bundle);
                request.setAttribute("currentLang", currentLocale.getLanguage());

                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(currentLocale);
                DateFormat dateFormatter = DateFormat.getDateInstance(DateFormat.FULL, currentLocale);

                request.setAttribute("formattedPrice", currencyFormatter.format(14999.50));
                request.setAttribute("formattedDate", dateFormatter.format(new Date()));

                request.getRequestDispatcher("/syllabus/i18n-demo.jsp").forward(request, response);
                break;

            case "/syllabus/jndi":
                // Demonstrates JNDI concept and InitialContext mock lookup
                request.setAttribute("jndiResourceName", "java:comp/env/jdbc/shopsphereDS");
                request.setAttribute("jndiLookupStatus", "Configured via Tomcat server.xml Context Resource");
                request.getRequestDispatcher("/syllabus/jndi-demo.jsp").forward(request, response);
                break;

            case "/syllabus/url-connection":
                String targetUrl = request.getParameter("targetUrl");
                if (targetUrl == null || targetUrl.trim().isEmpty()) {
                    targetUrl = "https://api.github.com/zen";
                }
                StringBuilder content = new StringBuilder();
                int responseCode = 0;
                try {
                    URL url = new URL(targetUrl);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setConnectTimeout(3000);
                    conn.setReadTimeout(3000);
                    conn.setRequestProperty("User-Agent", "shopsphere-Demo/1.0");
                    responseCode = conn.getResponseCode();

                    try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                        String line;
                        while ((line = reader.readLine()) != null) {
                            content.append(line).append("\n");
                        }
                    }
                } catch (Exception e) {
                    content.append("Demonstration note: Connection timed out or blocked: ").append(e.getMessage());
                }

                request.setAttribute("testedUrl", targetUrl);
                request.setAttribute("httpStatusCode", responseCode);
                request.setAttribute("urlResponseContent", content.toString());
                request.getRequestDispatcher("/syllabus/url-connection-demo.jsp").forward(request, response);
                break;

            default:
                request.getRequestDispatcher("/syllabus/index.jsp").forward(request, response);
                break;
        }
    }
}

