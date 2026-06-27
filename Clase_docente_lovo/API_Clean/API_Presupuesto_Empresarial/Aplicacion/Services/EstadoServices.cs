using Aplicacion.DTOs.Estado;
using Aplicacion.Interfaces;
using Domain.Estado;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class EstadoServices
    {
        private readonly IEstadoRepository _repository;

        public EstadoServices(IEstadoRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Estado_listar>> Listar_Cat_Estado_Async()
        {
            return await _repository.Listar_Cat_EstadoAsync();
        }

        public async Task<IEnumerable<DM_Estado_listar>> Filtrar_Cat_Estado_Async(EstadoFiltrarDTOs dto)
        {
            var modelo = new DM_Estado_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Filtrar_Cat_EstadoAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_Estado_Async(EstadoCrearDTOs dto)
        {
            var modelo = new DM_Estado_crear
            {
                Estado = dto.Estado,
                Id_Creador = dto.Id_Creador
            };
            return await _repository.Crear_Cat_EstadoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Estado_Async(EstadoActualizarDTOs dto)
        {
            var modelo = new DM_Estado_actualizar
            {
                Id_Estado = dto.Id_Estado,
                Estado = dto.Estado,
                Id_Modificador = dto.Id_Modificador,
                Activo = dto.Activo
            };
            return await _repository.Actualizar_Cat_EstadoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Estado_Async(EstadoEliminarDTOs dto)
        {
            var modelo = new DM_Estado_eliminar
            {
                Id_Estado = dto.Id_Estado,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_EstadoAsync(modelo);
        }
    }
}
