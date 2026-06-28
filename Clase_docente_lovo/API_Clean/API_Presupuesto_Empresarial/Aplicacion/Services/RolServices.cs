using Aplicacion.DTOs.Rol;
using Aplicacion.Interfaces;
using Domain.Rol;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class RolServices
    {
        private readonly IRolRepository _repository;

        public RolServices(IRolRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Rol_listar>> Listar_Cat_Roles_Async()
        {
            return await _repository.Listar_Cat_RolesAsync();
        }

        public async Task<IEnumerable<DM_Rol_listar>> Filtrar_Cat_Roles_Async(RolFiltrarDTOs dto)
        {
            var modelo = new DM_Rol_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Rol = dto.Id_Rol
            };
            return await _repository.Filtrar_Cat_RolesAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_Roles_Async(RolCrearDTOs dto)
        {
            var modelo = new DM_Rol_crear
            {
                Nombre = dto.Nombre,
                Descripcion = dto.Descripcion,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Crear_Cat_RolesAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Roles_Async(RolActualizarDTOs dto)
        {
            var modelo = new DM_Rol_actualizar
            {
                Id_Rol = dto.Id_Rol,
                Nombre = dto.Nombre,
                Descripcion = dto.Descripcion,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_Cat_RolesAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Roles_Async(RolEliminarDTOs dto)
        {
            var modelo = new DM_Rol_eliminar
            {
                Id_Rol = dto.Id_Rol,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_RolesAsync(modelo);
        }
    }
}
