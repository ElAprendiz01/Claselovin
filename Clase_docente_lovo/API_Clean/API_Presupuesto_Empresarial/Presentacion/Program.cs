using System.Text;
using Infraestructura.DB;


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// Configuración de CORS
builder.Services.AddCors(op =>
{
    op.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyHeader()
              .AllowAnyMethod()
              .AllowAnyOrigin();
    });
});


// Conexión base de datos 
var connectionString = builder.Configuration.GetConnectionString("Default");
builder.Services.AddSingleton(new DBconexionfactory(connectionString!));

// Add services to the container.

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


app.UseCors("AllowAll"); // Primero CORS

app.UseSwagger();
app.UseSwaggerUI(s =>
{
    s.SwaggerEndpoint("/swagger/v1/swagger.json", "ApiPresupuestoEmpresarial");
    s.RoutePrefix = string.Empty;
});

app.UseAuthentication();
app.UseAuthorization(); // Único punto de autorización

app.MapControllers();

app.Run();