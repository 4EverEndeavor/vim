#1:insert#

import com.fasterxml.jackson.annotation.JsonCreator;
import #2:insert#;
import com.rhombus.common.api.RUUID;
import com.rhombus.common.api.SelectiveUpdateUniversal;

public class #3:insert# extends SelectiveUpdateUniversal<#4:insert#>
{
    public #5:insert#(RUUID #6:insert#, RUUID #7:insert#)
    {
        super(new #8:insert#());
        obj().setOrgUuid(#9:insert#);
        obj().setUuid(#10:insert#);
    }

    /**
     * No-arg constructor for Jackson only. Others should use
     * {@link #ThreatCaseSelectiveUpdateType(RUUID, RUUID)} to avoid bugs where
     * uuid is not set
     */
    @JsonCreator
    private #11:insert#()
    {
        this(null, null);
    }
}

