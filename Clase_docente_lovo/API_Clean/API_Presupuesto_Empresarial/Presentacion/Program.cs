using System.Text;
using Infraestructura.DB;
using Aplicacion.Interfaces;
using Aplicacion.Services;
using Infraestructura.Repository;


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
builder.Services.AddScoped<IEstadoRepository, EstadoRepository>();
builder.Services.AddScoped<EstadoServices>();
builder.Services.AddScoped<ITipoCatalogoRepository, TipoCatalogoRepository>();
builder.Services.AddScoped<TipoCatalogoServices>();
builder.Services.AddScoped<ICatGeneralRepository, CatGeneralRepository>();
builder.Services.AddScoped<CatGeneralServices>();
builder.Services.AddScoped<IMonedaRepository, MonedaRepository>();
builder.Services.AddScoped<MonedaServices>();
builder.Services.AddScoped<IRolRepository, RolRepository>();
builder.Services.AddScoped<RolServices>();
builder.Services.AddScoped<IDatosPersonalesRepository, DatosPersonalesRepository>();
builder.Services.AddScoped<DatosPersonalesServices>();
builder.Services.AddScoped<IContactoRepository, ContactoRepository>();
builder.Services.AddScoped<ContactoServices>();
builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>();
builder.Services.AddScoped<UsuarioServices>();
builder.Services.AddScoped<IPermisosOpcionesRepository, PermisosOpcionesRepository>();
builder.Services.AddScoped<PermisosOpcionesServices>();
builder.Services.AddScoped<IDepartamentoRepository, DepartamentoRepository>();
builder.Services.AddScoped<DepartamentoServices>();
builder.Services.AddScoped<ICentroCostoRepository, CentroCostoRepository>();
builder.Services.AddScoped<CentroCostoServices>();
builder.Services.AddScoped<IPresupuestoRepository, PresupuestoRepository>();
builder.Services.AddScoped<PresupuestoServices>();
builder.Services.AddScoped<IDetallePresupuestoRepository, DetallePresupuestoRepository>();
builder.Services.AddScoped<DetallePresupuestoServices>();
builder.Services.AddScoped<IAjustePresupuestoRepository, AjustePresupuestoRepository>();
builder.Services.AddScoped<AjustePresupuestoServices>();
builder.Services.AddScoped<IGastoRepository, GastoRepository>();
builder.Services.AddScoped<GastoServices>();

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