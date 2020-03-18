package team.abc.ssm.modules.document.paper.entity;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

@Data
public class ReprintAuthorEntry extends DataEntity<ReprintAuthorEntry> {
    private String paper;//论文uuid
    private String paperName;//论文名称
    private String authorName;
    private String authorWorkId;
    private String realName;
    private String status;

    public ReprintAuthorEntry() {

    }

    public ReprintAuthorEntry(String paper, String authorName, String authorWorkId, String realName, String status) {
        this.paper = paper;
        this.authorName = authorName;
        this.authorWorkId = authorWorkId;
        this.realName = realName;
        this.status = status;
    }

    public String getString() {
        String str = this.realName + "," + this.authorWorkId;
        return str;
    }
}
