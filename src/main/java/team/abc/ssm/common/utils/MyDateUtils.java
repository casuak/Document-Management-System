package team.abc.ssm.common.utils;

import org.apache.commons.lang.time.DateUtils;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * @ClassName DateUtils
 * @Description 日期工具类
 * @Author zm
 * @Date 2019/10/13 14:57
 * @Version 1.0
 **/
public class MyDateUtils {
    private static Calendar c = new GregorianCalendar(1900,0,-1);
    private static Date d = c.getTime();

    public static Date transStampToDate(String timeStamp){

        return DateUtils.addDays(d,Integer.parseInt(timeStamp));
    }
}
