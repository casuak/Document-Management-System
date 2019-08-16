package team.abc.ssm.modules.doc.entity;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

@Data
public class Fund extends DataEntity<Fund> {

//    指标名称
    private String metricName;
//    姓名
    private String personName;
//    年份
    private Integer projectYear;
//    项目名称
    private String projectName;
//    金额（万元）
    private Integer projectMoney;
}
