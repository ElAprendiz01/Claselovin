using Aplicacion.DTOs.Usuario;
using Aplicacion.Interfaces;
using Domain.Usuario;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class UsuarioServices
    {
        private readonly IUsuarioRepository _repository;

        public UsuarioServices(IUsuarioRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Usuario_listar>> Listar_Cat_Usuarios_Async()
        {
            return await _repository.Listar_Cat_UsuariosAsync();
        }

        public async Task<IEnumerable<DM_Usuario_listar>> Filtrar_Cat_Usuarios_Async(UsuarioFiltrarDTOs dto)
        {
            var modelo = new DM_Usuario_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Usuario = dto.Id_Usuario,
                Id_Rol = dto.Id_Rol
            };
            return await _repository.Filtrar_Cat_UsuariosAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_Usuarios_Async(UsuarioCrearDTOs dto)
        {
            var modelo = new DM_Usuario_crear
            {
                Usuario = dto.Usuario,
                Contrasena = dto.Contrasena,
                Id_Persona = dto.Id_Persona,
                Id_Rol = dto.Id_Rol,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Crear_Cat_UsuariosAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Usuarios_Async(UsuarioActualizarDTOs dto)
        {
            var modelo = new DM_Usuario_actualizar
            {
                Id_Usuario = dto.Id_Usuario,
                Usuario = dto.Usuario,
                Contrasena = dto.Contrasena,
                Id_Persona = dto.Id_Persona,
                Id_Rol = dto.Id_Rol,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_Cat_UsuariosAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Usuarios_Async(UsuarioEliminarDTOs dto)
        {
            var modelo = new DM_Usuario_eliminar
            {
                Id_Usuario = dto.Id_Usuario,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_UsuariosAsync(modelo);
        }
    }
}
