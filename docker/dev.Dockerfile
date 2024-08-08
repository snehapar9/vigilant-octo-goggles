# Use the official .NET 8.0 SDK preview image
FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build

# Set the working directory for the build process
WORKDIR /app

# Copy the project file and restore dependencies
COPY /src/MyDotnetApp/*.csproj ./MyDotnetApp/
RUN dotnet restore ./MyDotnetApp/MyDotnetApp.csproj

# Copy the rest of the source code
COPY /src/MyDotnetApp/. ./MyDotnetApp/

# Publish the application
RUN dotnet publish ./MyDotnetApp/MyDotnetApp.csproj -c Release -o /out

# Use the official .NET 8.0 ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-preview AS runtime

# Set the working directory for the runtime process
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /out .

# Expose the port on which the application will run
EXPOSE 80

# Set the entry point for the application
ENTRYPOINT ["dotnet", "MyDotnetApp.dll"]
