package team.abc.ssm.common.utils.excel;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import team.abc.ssm.common.utils.SystemPath;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class ExcelUtils {

    public static Sheet getSheet(String excelName, int sheetIndex) throws IOException {
        File tempDir = new File(SystemPath.getTempDirPath());
        File excel = new File(tempDir, excelName);
        // 创建workbook
        InputStream is;
        Workbook workbook;
        is = new FileInputStream(excel.getPath());
        workbook = new XSSFWorkbook(is);
        // 只取第一个sheet
        return workbook.getSheetAt(sheetIndex);
    }

    public static Object getCellValue(Row row, int colIndex) {
        Object val;
        try {
            Cell cell = row.getCell(colIndex);
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
}
