<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Result</title>
</head>
<body>
    <h1>Registration Successful</h1>
    <hr>
    <h3>Student Details</h3>
    <p>Name: ${name}</p>
    <p>Email: ${email}</p>
    <p>Course: ${course}</p>
    <p>Age: ${age}</p>
    <% if (request.getAttribute("phone") != null) { %>
    <p>Phone: ${phone}</p>
    <% } %>
    <br>
    <a href="student.jsp">Back to Form</a>
</body>
</html>
