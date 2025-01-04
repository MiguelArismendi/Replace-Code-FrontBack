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
            // Ruta del archivo .aspx
            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string FormularioModificar = Path.Combine(RutaProyecto, "Archivos", "EvaluacionMedicaGeneral.aspx.vb");

            // Verificar si el archivo existe
            if (!File.Exists(FormularioModificar))
            {
                Console.WriteLine($"El archivo no existe: {FormularioModificar}");
                return;
            }

            // Leer el contenido del archivo
            string contenido = File.ReadAllText(FormularioModificar);
            string extension = Path.GetExtension(FormularioModificar).ToLower();
            string contenidoModificado = contenido;

            if (extension == ".aspx")
            {
                string PatronFuncionSelecciona = @"if\s*\(\s*\$get\s*\(\s*['""]HdfHistoricoDiagnostico['""]\s*\)\.value\s*!=\s*[""']\s*[""']\s*\)\s*\{";
                string LineaFuncionSelecciona = "DiagnosticosJsonSelecciona();";

                contenidoModificado = Regex.Replace(contenido, PatronFuncionSelecciona, m => $"{LineaFuncionSelecciona}\n{m.Value}", RegexOptions.IgnoreCase);


                // Expresión regular para identificar el fieldset
                string patronFieldset = @"<fieldset[^>]*(id|class)\s*=\s*[""']?FDiagnosticos[""']?[^>]*>.*?</fieldset>";

                // Reemplazo con el nuevo contenido
                string nuevoContenido = @"<asp:DiagnosticosJson runat=""server"" ID=""DiagnosticosJson"" />";

                // Realizar el reemplazo
                contenidoModificado = Regex.Replace(contenidoModificado, patronFieldset, nuevoContenido, RegexOptions.Singleline);


                //reemplazando los if

                // Expresión regular para identificar los bloques de if, incluyendo corchetes internos
                string patronIf = @"if\s*\(\s*\$get\(['""]?(HdfHistoricoDiagnostico|TbHistoricoDiagnostico|HdfDiagnosticos)['""]?\)[^}]*\{([^{}]*\{[^}]*\}[^{}]*)*\}";
                string patronIfTabla = @"if\s*\(\s*\$get\(""TbHistoricoDiagnostico""\)\.getElementsByTagName\('tbody'\)\[0\]\.getElementsByTagName\('tr'\)\.length\s*==\s*0\)[^}]*\{[^}]*\}";

                // Reemplazo para comentar los bloques if
                contenidoModificado = Regex.Replace(contenidoModificado, patronIf, m =>
                {
                    return $"/*\n{m.Value}\n*/";  // Comenta el bloque if encontrado
                }, RegexOptions.Singleline);

                // Reemplazo adicional para comentar el código que no está dentro de los bloques if
                string patronAsignacion = @"\$get\(['""]?(HdfHistoricoDiagnostico|HdfDiagnosticos)['""]?\)\.value\s*=\s*""\s*"";";
                contenidoModificado = Regex.Replace(contenidoModificado, patronAsignacion, m =>
                {
                    return $"/*\n{m.Value}\n*/";  // Comenta la asignación que no está dentro de los if
                });

                // Reemplazo para comentar el bloque if
                contenidoModificado = Regex.Replace(contenidoModificado, patronIfTabla, m =>
                {
                    return $"/*\n{m.Value}\n*/";  // Comentar solo este bloque if
                }, RegexOptions.Singleline);



                string ExpresionContenido = @"<asp:Content\s+[^>]*\bID\s*=\s*""Content4""[^>]*>";
                string NuevaLineaCodigo = @"<asp:Content ID=""Content0"" ContentPlaceHolderID=""H"" runat=""Server"">
    <style>
     .ui-menu {
      background: #86C1E6;
     }
    </style>
</asp:Content>

<%@ Register Src=""~/HistoriaClinica/DiagnosticosJson.ascx"" TagPrefix=""asp"" TagName=""DiagnosticosJson"" %>";


                contenidoModificado = Regex.Replace(contenidoModificado, ExpresionContenido, m => $"{NuevaLineaCodigo}\n{m.Value}", RegexOptions.IgnoreCase);




                string PatronReferencia = @"<link\s+[^>]*href\s*=\s*""\.\./Estilos/jquery-ui\.css""[^>]*>";


                contenidoModificado = Regex.Replace(contenidoModificado, PatronReferencia, match => $"<!-- {match.Value} -->");


                PatronReferencia = @"<script\s+[^>]*src\s*=\s*""\.\./Scripts/jquery-ui\.js""[^>]*>\s*</script>";


                contenidoModificado = Regex.Replace(contenidoModificado, PatronReferencia, match => $"<!-- {match.Value} -->");

            }
            else if (extension == ".vb")
            {
                // Bloques específicos que necesitas comentar
                string[] patrones = new string[]
                {
            @"SqlDs\.SelectCommand\s*=\s*""HistoriaClinica\.HistoricoDiagnosticosSelecciona""[\s\S]*?End If",
            @"SqlDs\.SelectCommand\s*=\s*""HistoriaClinica\.DiagnosticosSelecciona""[\s\S]*?End If"
                };

                foreach (var patron in patrones)
                {
                    contenidoModificado = Regex.Replace(
                        contenidoModificado,
                        patron,
                        match => "' " + match.Value.Replace("\r\n", "\r\n' "),
                        RegexOptions.Singleline
                    );
                }
            }


            // Guardar los cambios en el archivo
            File.WriteAllText(FormularioModificar, contenidoModificado);
            Console.WriteLine("Reemplazo completado.");







        }
    }
}
