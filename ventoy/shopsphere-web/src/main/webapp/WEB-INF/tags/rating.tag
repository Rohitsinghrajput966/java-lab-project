<%@ tag description="Reusable Star Rating Tag" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ attribute name="score" type="java.lang.Double" required="true" %>

<span class="text-warning small" title="${score} out of 5 stars">
    <c:forEach begin="1" end="5" var="i">
        <c:choose>
            <c:when test="${score >= i}">
                <i class="bi bi-star-fill"></i>
            </c:when>
            <c:when test="${score >= (i - 0.5)}">
                <i class="bi bi-star-half"></i>
            </c:when>
            <c:otherwise>
                <i class="bi bi-star"></i>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <span class="text-muted ms-1" style="font-size: 0.75rem;">(${score})</span>
</span>
