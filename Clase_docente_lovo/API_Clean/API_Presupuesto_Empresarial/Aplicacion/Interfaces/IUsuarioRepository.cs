using Domain.Usuario;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IUsuarioRepository
    {
        Task<IEnumerable<DM_Usuario_listar>> Listar_Cat_UsuariosAsync();
        Task<IEnumerable<DM_Usuario_listar>> Filtrar_Cat_UsuariosAsync(DM_Usuario_filtrar modelo);
        Task<DBResult> Crear_Cat_UsuariosAsync(DM_Usuario_crear modelo);
        Task<DBResult> Actualizar_Cat_UsuariosAsync(DM_Usuario_actualizar modelo);
        Task<DBResult> Eliminar_Cat_UsuariosAsync(DM_Usuario_eliminar modelo);
    }
}
