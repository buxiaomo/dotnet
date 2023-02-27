# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/aspnet:6.0
RUN useradd -m -d /app appadmin
WORKDIR /app
COPY --chown=appadmin:appadmin publish /app
ENV ASPNETCORE_URLS http://+:5000
EXPOSE 5000
USER appadmin
CMD ["dotnet", "myWebApp.dll"]