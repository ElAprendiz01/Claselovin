using Aplicacion.DTOs.PermisosOpciones;
using Aplicacion.Interfaces;
using Domain.PermisosOpciones;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class PermisosOpcionesServices
    {
        private readonly IPermisosOpcionesRepository _repository;

        public PermisosOpcionesServices(IPermisosOpcionesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_PermisosOpciones_listar>> Listar_Cat_PermisosOpciones_Async()
        {
            return await _repository.Listar_Cat_PermisosOpcionesAsync();
        }

        public async Task<IEnumerable<DM_PermisosOpciones_listar>> Filtrar_Cat_PermisosOpciones_Async(PermisosOpcionesFiltrarDTOs dto)
        {
            var modelo = new DM_PermisosOpciones_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Permiso = dto.Id_Permiso,
                Id_Rol = dto.Id_Rol
            };
            return await _repository.Filtrar_Cat_PermisosOpcionesAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_PermisosOpciones_Async(PermisosOpcionesCrearDTOs dto)
        {
            var modelo = new DM_PermisosOpciones_crear
            {
                Id_Rol = dto.Id_Rol,
                Modulo = dto.Modulo,
                Puede_Crear = dto.Puede_Crear,
                Puede_Leer = dto.Puede_Leer,
                Puede_Actualizar = dto.Puede_Actualizar,
                Puede_Eliminar = dto.Puede_Eliminar,
                Id_Creador = dto.Id_Creador
            };
            return await _repository.Crear_Cat_PermisosOpcionesAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_PermisosOpciones_Async(PermisosOpcionesActualizarDTOs dto)
        {
            var modelo = new DM_PermisosOpciones_actualizar
            {
                Id_Permiso = dto.Id_Permiso,
                Id_Rol = dto.Id_Rol,
                Modulo = dto.Modulo,
                Puede_Crear = dto.Puede_Crear,
                Puede_Leer = dto.Puede_Leer,
                Puede_Actualizar = dto.Puede_Actualizar,
                Puede_Eliminar = dto.Puede_Eliminar
            };
            return await _repository.Actualizar_Cat_PermisosOpcionesAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_PermisosOpciones_Async(PermisosOpcionesEliminarDTOs dto)
        {
            var modelo = new DM_PermisosOpciones_eliminar
            {
                Id_Permiso = dto.Id_Permiso,
                Id_Usuario_Ejecutor = dto.Id_Usuario_Ejecutor
            };
            return await _repository.Eliminar_Cat_PermisosOpcionesAsync(modelo);
        }
    }
}
