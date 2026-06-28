using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.CentroCosto;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CentroCostoController : ControllerBase
    {
        private readonly CentroCostoServices _service;

        public CentroCostoController(CentroCostoServices service)
        {
            _service = service;
        }

        #region lectura_catalogo

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Cat_CentrosCosto()
        {
            try
            {
                var lista = await _service.Listar_Cat_CentrosCosto_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron centros de costo." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_Cat_CentrosCosto([FromBody] CentroCostoFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _service.Filtrar_Cat_CentrosCosto_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron centros de costo que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_catalogo

        [HttpPost("crear")]
        public async Task<IActionResult> Crear_Cat_CentrosCosto([FromBody] CentroCostoCrearDTOs centroCosto)
        {
            try
            {
                if (!ModelState.IsValid || centroCosto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _service.Crear_Cat_CentrosCosto_Async(centroCosto);

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
        public async Task<IActionResult> Actualizar_Cat_CentrosCosto([FromBody] CentroCostoActualizarDTOs centroCosto)
        {
            try
            {
                if (centroCosto == null || !centroCosto.Id_Centro_Costo.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del centro de costo es obligatorio." });
                }

                DBResult resultado = await _service.Actualizar_Cat_CentrosCosto_Async(centroCosto);

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
        public async Task<IActionResult> Eliminar_Cat_CentrosCosto([FromBody] CentroCostoEliminarDTOs centroCosto)
        {
            try
            {
                if (centroCosto == null || !centroCosto.Id_Centro_Costo.HasValue || !centroCosto.Id_Modificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del centro de costo y el ID del modificador son requeridos." });
                }

                DBResult resultado = await _service.Eliminar_Cat_CentrosCosto_Async(centroCosto);

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
