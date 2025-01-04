using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;
using static System.Net.Mime.MediaTypeNames;

namespace Replace_Code_FrontBack
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string FormularioModificar = Path.Combine(RutaProyecto, "Archivos", "EvaluacionMedicaGeneral.aspx");

            if (!File.Exists(FormularioModificar))
            {
                Console.WriteLine($"El archivo no existe: {FormularioModificar}");
                return;
            }

            // Leer el contenido del archivo
            string ContenidoFormulario = File.ReadAllText(FormularioModificar);
            string ExtensionFormulario = Path.GetExtension(FormularioModificar).ToLower();
            string ContenidoModificado = ContenidoFormulario;
            string PatronExpresionRegular;
            string NuevaLineaReemplazar;

            if (ExtensionFormulario == ".aspx")
            {
                // Se busca el inicio del llenado del historico de los diagnósticos y se agrega la función que reemplaza este llenado
                PatronExpresionRegular = @"if\s*\(\s*\$get\s*\(\s*['""]HdfHistoricoDiagnostico['""]\s*\)\.value\s*!=\s*[""']\s*[""']\s*\)\s*\{";
                NuevaLineaReemplazar = "DiagnosticosJsonSelecciona();";
                ContenidoModificado = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m => $"{NuevaLineaReemplazar}\n{m.Value}", RegexOptions.IgnoreCase);

                // Se busca el fieldset en el HTML que contiene los diagnósticos y se reemplaza por el control de usuario
                PatronExpresionRegular = @"<fieldset[^>]*(id|class)\s*=\s*[""']?FDiagnosticos[""']?[^>]*>.*?</fieldset>";
                NuevaLineaReemplazar = @"<asp:DiagnosticosJson runat=""server"" ID=""DiagnosticosJson"" />";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, NuevaLineaReemplazar, RegexOptions.Singleline);

                // Se busca en el archivo el bloque de código que llena el histórico y los diagnósticos para comentar todo este código
                PatronExpresionRegular = @"if\s*\(\s*\$get\(['""]?(HdfHistoricoDiagnostico|TbHistoricoDiagnostico|HdfDiagnosticos)['""]?\)[^}]*\{([^{}]*\{[^}]*\}[^{}]*)*\}";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, m => { return $"/*\n{m.Value}\n*/"; }, RegexOptions.Singleline);

                //Se busca en el archivo el bloque de código que limpia las variables que llenan los diagnósticos y se comentan
                PatronExpresionRegular = @"\$get\(['""]?(HdfHistoricoDiagnostico|HdfDiagnosticos)['""]?\)\.value\s*=\s*""\s*"";";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, m => { return $"/*\n{m.Value}\n*/"; });

                //Se busca en el archivo el bloque de validación de la tabla del histórico de los diagnósticos y se comenta
                PatronExpresionRegular = @"if\s*\(\s*\$get\(""TbHistoricoDiagnostico""\)\.getElementsByTagName\('tbody'\)\[0\]\.getElementsByTagName\('tr'\)\.length\s*==\s*0\)[^}]*\{[^}]*\}";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, m => { return $"/*\n{m.Value}\n*/"; }, RegexOptions.Singleline);


                //Se busca el inicio del content 4 y se agrega el registro del archivo de usuario y un content0 con el style necesario para que funcionen los autocomplete
                PatronExpresionRegular = @"<asp:Content\s+[^>]*\bID\s*=\s*""Content4""[^>]*>";
                NuevaLineaReemplazar = @"<asp:Content ID=""Content0"" ContentPlaceHolderID=""H"" runat=""Server"">
<style>
     .ui-menu {
      background: #86C1E6;
     }
</style>
</asp:Content>

<%@ Register Src=""~/HistoriaClinica/DiagnosticosJson.ascx"" TagPrefix=""asp"" TagName=""DiagnosticosJson"" %>";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, m => $"{NuevaLineaReemplazar}\n{m.Value}", RegexOptions.IgnoreCase);

                //Se busca en el código el bloque que trae los estilos y se comentan ya que interfieren con el estilo del control de usuario
                PatronExpresionRegular = @"<link\s+[^>]*href\s*=\s*""\.\./Estilos/jquery-ui\.css""[^>]*>";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, match => $"<!-- {match.Value} -->");

                //Se busca en el código el bloque que trae los estilos y se comentan ya que interfieren con el estilo del control de usuario
                PatronExpresionRegular = @"<script\s+[^>]*src\s*=\s*""\.\./Scripts/jquery-ui\.js""[^>]*>\s*</script>";
                ContenidoModificado = Regex.Replace(ContenidoModificado, PatronExpresionRegular, match => $"<!-- {match.Value} -->");
            }
            else if (ExtensionFormulario == ".vb")
            {
                // Bloques específicos que necesitas comentar
                string[] PatronesExpresionesRegulares = new string[]
                {
            @"SqlDs\.SelectCommand\s*=\s*""HistoriaClinica\.HistoricoDiagnosticosSelecciona""[\s\S]*?End If",
            @"SqlDs\.SelectCommand\s*=\s*""HistoriaClinica\.DiagnosticosSelecciona""[\s\S]*?End If"
                };

                foreach (var Patron in PatronesExpresionesRegulares)
                {
                    ContenidoModificado = Regex.Replace(
                        ContenidoModificado,
                        Patron,
                        Concidencia => "' " + Concidencia.Value.Replace("\r\n", "\r\n' "),
                        RegexOptions.Singleline
                    );
                }
            }
            
            File.WriteAllText(FormularioModificar, ContenidoModificado);
            Console.WriteLine("Reemplazo completado.");
        }
    }
}
