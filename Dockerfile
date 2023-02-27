# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /publish
COPY publish .
EXPOSE 80
CMD ["dotnet", "myWebApp.dll"]