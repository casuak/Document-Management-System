package team.abc.ssm.common.utils;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import team.abc.ssm.common.utils.SystemPath;

import java.io.*;
import java.math.BigDecimal;

public class ExcelUtils {

    // 获取excel文件中指定sheet
    public static Sheet getSheet(File excel, int sheetIndex) throws IOException {
        // 创建workbook
        InputStream is;
        Workbook workbook;
        is = new FileInputStream(excel.getPath());
        workbook = new XSSFWorkbook(is);
        // 只取第一个sheet
        return workbook.getSheetAt(sheetIndex);
    }

    // 通过table中的字段类型获取对应excel类型值
    public static Object getCellValueByFieldType(Cell cell, String fieldType) {
        Object val = null;
        try {
            switch (fieldType) {
                case "varchar":
                    val = cell.getStringCellValue();
                    break;
                case "int":
                    val = (int) cell.getNumericCellValue();
                case "decimal":
                    // TODO
                    val = cell.getNumericCellValue();
                    break;
                case "float":
                    val = (float) cell.getNumericCellValue();
                    break;
                case "double":
                    val = cell.getNumericCellValue();
                    break;
                case "datetime":
                    val = cell.getDateCellValue();
                    break;
            }
        } catch (Exception e) {
            // do nothing
        }
        return val;
    }

    // 获取excel行中的指定列中的值
    public static Object getCellValue(Cell cell) {
        Object val;
        try {
            if (cell != null) {
                switch (cell.getCellType()) {
                    case Cell.CELL_TYPE_NUMERIC:
                        val = cell.getNumericCellValue();
                        break;
                    case Cell.CELL_TYPE_STRING:
                        val = cell.getStringCellValue();
                        break;
                    case Cell.CELL_TYPE_FORMULA:
                        val = cell.getCellFormula();
                        break;
                    case Cell.CELL_TYPE_BOOLEAN:
                        val = cell.getBooleanCellValue();
                        break;
                    case Cell.CELL_TYPE_ERROR:
                        val = cell.getErrorCellValue();
                        break;
                    default:
                        val = null;
                        break;
                }
            } else val = null;
        } catch (Exception e) {
            return null;
        }
        return val;
    }

    /**
     * @param fileName the template file you want to know
     * @return full path
     */
    public static String getTemplateFileFullPath(String fileName){
        return SystemPath.getRootPath() + SystemPath.getExcelTemplatePath() + fileName;
    }
}
