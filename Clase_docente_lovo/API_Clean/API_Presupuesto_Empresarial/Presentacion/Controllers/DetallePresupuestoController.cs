using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.DetallePresupuesto;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DetallePresupuestoController : ControllerBase
    {
        private readonly DetallePresupuestoServices _servicio;

        public DetallePresupuestoController(DetallePresupuestoServices servicio)
        {
            _servicio = servicio;
        }

        #region lectura_detalle_presupuesto

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_DetallePresupuesto()
        {
            try
            {
                var lista = await _servicio.Listar_DetallePresupuesto_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles de presupuesto." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_DetallePresupuesto([FromBody] DetallePresupuestoFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _servicio.Filtrar_DetallePresupuesto_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles de presupuesto que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_detalle_presupuesto

        [HttpPost("crear")]
        public async Task<IActionResult> Crear_DetallePresupuesto([FromBody] DetallePresupuestoCrearDTOs detalle)
        {
            try
            {
                if (!ModelState.IsValid || detalle == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _servicio.Crear_DetallePresupuesto_Async(detalle);

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
        public async Task<IActionResult> Actualizar_DetallePresupuesto([FromBody] DetallePresupuestoActualizarDTOs detalle)
        {
            try
            {
                if (detalle == null || !detalle.Id_Presupuesto_Detalle.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del detalle es obligatorio." });
                }

                DBResult resultado = await _servicio.Actualizar_DetallePresupuesto_Async(detalle);

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
        public async Task<IActionResult> Eliminar_DetallePresupuesto([FromBody] DetallePresupuestoEliminarDTOs detalle)
        {
            try
            {
                if (detalle == null || !detalle.Id_Presupuesto_Detalle.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del detalle de presupuesto es requerido." });
                }

                DBResult resultado = await _servicio.Eliminar_DetallePresupuesto_Async(detalle);

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
