FROM tomcat:9.0-jdk8-openjdk

LABEL maintainer="Department of CSE, RRIT"
LABEL description="Fuzzy Identity-Based Data Integrity Auditing for Reliable Cloud Storage Systems"

# Copy the pre-built WAR archive into Tomcat webapps
COPY "Fuzzy identity/SOURCE CODE/Fuzzy_IDbased_DataIntegrity/dist/Fuzzy_IDbased_DataIntegrity.war" /usr/local/tomcat/webapps/ROOT.war

# Set environment variables for database connectivity
ENV DB_HOST=db \
    DB_PORT=3306 \
    DB_NAME=fuzzy \
    DB_USER=root \
    DB_PASS=root

EXPOSE 8080

CMD ["catalina.sh", "run"]
