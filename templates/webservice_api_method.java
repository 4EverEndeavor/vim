    @Operation(description = "<TAG>", tags = { "<TAG>" })
    @POST
    @Path("/<TAG>")
    @AccessControl(
            functionality = { Functionality.<TAG> },
            partnerFunctionality = { PartnerFunctionality.<TAG> })
    @WebSecurity(clients = { Client.<TAG> })
    @Audit(actions = Action.<TAG>)
    <TAG>WSResponse <TAG>(final <TAG>WSRequest request) throws Exception;
