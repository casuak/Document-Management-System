package team.abc.ssm.modules.document.docStatistics.entity;

import lombok.Data;

/**
 * @author zm
 * @description 统计项
 * @data 2019/5/19
 */
@Data
public class Statistics {
    private String type;

    private Integer totalDocNum;

    private Integer teacherDocNum;

    private Integer studentDocNum;

    private Integer postdoctoralDocNum;
}
