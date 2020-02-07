package team.abc.ssm.modules.document.journal.entity;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

import java.util.Date;

@Data
public class Journal extends DataEntity<Journal> {

    private double impactFactor;
    private String journalDivision;
    private Date journalYear;
    private String journalTitle;
    private String issn;
}
