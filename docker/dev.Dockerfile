# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory for the build process
WORKDIR /app

# Copy the project file and restore dependencies
COPY ../src/MyDotnetApp/*.csproj ./MyDotnetApp/
RUN dotnet restore ./MyDotnetApp/MyDotnetApp.csproj

# Copy the rest of the source code
COPY ../src/MyDotnetApp/. ./MyDotnetApp/

# Publish the application
RUN dotnet publish ./MyDotnetApp/MyDotnetApp.csproj -c Release -o /out

# Use the official .NET runtime image for the runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Set the working directory for the runtime process
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /out .

# Expose the port on which the application will run
EXPOSE 80

# Set the entry point for the application
ENTRYPOINT ["dotnet", "MyDotnetApp.dll"]
