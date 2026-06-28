using Aplicacion.DTOs.CentroCosto;
using Aplicacion.Interfaces;
using Domain.CentroCosto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class CentroCostoServices
    {
        private readonly ICentroCostoRepository _repository;

        public CentroCostoServices(ICentroCostoRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_CentroCosto_listar>> Listar_Cat_CentrosCosto_Async()
        {
            return await _repository.Listar_Cat_CentrosCostoAsync();
        }

        public async Task<IEnumerable<DM_CentroCosto_listar>> Filtrar_Cat_CentrosCosto_Async(CentroCostoFiltrarDTOs dto)
        {
            var modelo = new DM_CentroCosto_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Centro_Costo = dto.Id_Centro_Costo,
                Id_Departamento = dto.Id_Departamento
            };
            return await _repository.Filtrar_Cat_CentrosCostoAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_CentrosCosto_Async(CentroCostoCrearDTOs dto)
        {
            var modelo = new DM_CentroCosto_crear
            {
                Id_Departamento = dto.Id_Departamento,
                Nombre_Centro = dto.Nombre_Centro,
                Codigo_Contable = dto.Codigo_Contable,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Crear_Cat_CentrosCostoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_CentrosCosto_Async(CentroCostoActualizarDTOs dto)
        {
            var modelo = new DM_CentroCosto_actualizar
            {
                Id_Centro_Costo = dto.Id_Centro_Costo,
                Id_Departamento = dto.Id_Departamento,
                Nombre_Centro = dto.Nombre_Centro,
                Codigo_Contable = dto.Codigo_Contable,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_Cat_CentrosCostoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_CentrosCosto_Async(CentroCostoEliminarDTOs dto)
        {
            var modelo = new DM_CentroCosto_eliminar
            {
                Id_Centro_Costo = dto.Id_Centro_Costo,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_CentrosCostoAsync(modelo);
        }
    }
}
