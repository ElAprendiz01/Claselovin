using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.Gasto;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GastoController : ControllerBase
    {
        private readonly GastoServices _servicio;

        public GastoController(GastoServices servicio)
        {
            _servicio = servicio;
        }

        #region lectura_gasto

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Gasto()
        {
            try
            {
                var lista = await _servicio.Listar_Gasto_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron gastos." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_Gasto([FromBody] GastoFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _servicio.Filtrar_Gasto_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron gastos que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_gasto

        [HttpPost("crear")]
        public async Task<IActionResult> Crear_Gasto([FromBody] GastoCrearDTOs gasto)
        {
            try
            {
                if (!ModelState.IsValid || gasto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _servicio.Crear_Gasto_Async(gasto);

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
        public async Task<IActionResult> Actualizar_Gasto([FromBody] GastoActualizarDTOs gasto)
        {
            try
            {
                if (gasto == null || !gasto.Id_Gasto.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del gasto es obligatorio." });
                }

                DBResult resultado = await _servicio.Actualizar_Gasto_Async(gasto);

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
        public async Task<IActionResult> Eliminar_Gasto([FromBody] GastoEliminarDTOs gasto)
        {
            try
            {
                if (gasto == null || !gasto.Id_Gasto.HasValue || !gasto.Id_Modificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del gasto y el ID del modificador son requeridos." });
                }

                DBResult resultado = await _servicio.Eliminar_Gasto_Async(gasto);

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
