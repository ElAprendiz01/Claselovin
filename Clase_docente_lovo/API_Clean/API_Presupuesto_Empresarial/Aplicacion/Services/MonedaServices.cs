using Aplicacion.DTOs.Moneda;
using Aplicacion.Interfaces;
using Domain.Moneda;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class MonedaServices
    {
        private readonly IMonedaRepository _repository;

        public MonedaServices(IMonedaRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Moneda_listar>> Listar_Cat_Monedas_Async()
        {
            return await _repository.Listar_Cat_MonedasAsync();
        }

        public async Task<IEnumerable<DM_Moneda_listar>> Filtrar_Cat_Monedas_Async(MonedaFiltrarDTOs dto)
        {
            var modelo = new DM_Moneda_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Moneda = dto.Id_Moneda
            };
            return await _repository.Filtrar_Cat_MonedasAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_Monedas_Async(MonedaCrearDTOs dto)
        {
            var modelo = new DM_Moneda_crear
            {
                Codigo_ISO = dto.Codigo_ISO,
                Nombre_Moneda = dto.Nombre_Moneda,
                Simbolo = dto.Simbolo
            };
            return await _repository.Crear_Cat_MonedasAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Monedas_Async(MonedaActualizarDTOs dto)
        {
            var modelo = new DM_Moneda_actualizar
            {
                Id_Moneda = dto.Id_Moneda,
                Codigo_ISO = dto.Codigo_ISO,
                Nombre_Moneda = dto.Nombre_Moneda,
                Simbolo = dto.Simbolo,
                Activo = dto.Activo
            };
            return await _repository.Actualizar_Cat_MonedasAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Monedas_Async(MonedaEliminarDTOs dto)
        {
            var modelo = new DM_Moneda_eliminar
            {
                Id_Moneda = dto.Id_Moneda
            };
            return await _repository.Eliminar_Cat_MonedasAsync(modelo);
        }
    }
}
