using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.AjustePresupuesto;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AjustePresupuestoController : ControllerBase
    {
        private readonly AjustePresupuestoServices _servicio;

        public AjustePresupuestoController(AjustePresupuestoServices servicio)
        {
            _servicio = servicio;
        }

        #region lectura_ajuste_presupuesto

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_AjustePresupuesto()
        {
            try
            {
                var lista = await _servicio.Listar_AjustePresupuesto_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron ajustes de presupuesto." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_AjustePresupuesto([FromBody] AjustePresupuestoFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _servicio.Filtrar_AjustePresupuesto_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron ajustes de presupuesto que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_ajuste_presupuesto

        [HttpPost("crear")]
        public async Task<IActionResult> Crear_AjustePresupuesto([FromBody] AjustePresupuestoCrearDTOs ajuste)
        {
            try
            {
                if (!ModelState.IsValid || ajuste == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _servicio.Crear_AjustePresupuesto_Async(ajuste);

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
