using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.Presupuesto;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PresupuestoController : ControllerBase
    {
        private readonly PresupuestoServices _servicio;

        public PresupuestoController(PresupuestoServices servicio)
        {
            _servicio = servicio;
        }

        #region lectura_presupuesto

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Presupuesto()
        {
            try
            {
                var lista = await _servicio.Listar_Presupuesto_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron presupuestos." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_Presupuesto([FromBody] PresupuestoFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _servicio.Filtrar_Presupuesto_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron presupuestos que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_presupuesto

        [HttpPost("crear")]
        public async Task<IActionResult> Crear_Presupuesto([FromBody] PresupuestoCrearDTOs presupuesto)
        {
            try
            {
                if (!ModelState.IsValid || presupuesto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _servicio.Crear_Presupuesto_Async(presupuesto);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPut("actualizar")]
        public async Task<IActionResult> Actualizar_Presupuesto([FromBody] PresupuestoActualizarDTOs presupuesto)
        {
            try
            {
                if (presupuesto == null || !presupuesto.Id_Presupuesto.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del presupuesto es obligatorio." });
                }

                DBResult resultado = await _servicio.Actualizar_Presupuesto_Async(presupuesto);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpDelete("eliminar")]
        public async Task<IActionResult> Eliminar_Presupuesto([FromBody] PresupuestoEliminarDTOs presupuesto)
        {
            try
            {
                if (presupuesto == null || !presupuesto.Id_Presupuesto.HasValue || !presupuesto.Id_Modificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del presupuesto y el ID del modificador son requeridos." });
                }

                DBResult resultado = await _servicio.Eliminar_Presupuesto_Async(presupuesto);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion
    }
}
