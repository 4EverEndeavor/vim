    public void insert#1:insert#(#2:insert#) throws Exception
    {
        final Item item = Item.fromJSON(_objectMapper.writeValueAsString(#3:insert#));

        final NameMap nameMap = new NameMap().with("##4:insert#", "#5:insert#");

        final PutItemSpec putItemSpec = new PutItemSpec()
                .withItem(item)
                .withConditionExpression("attribute_not_exists(##6:insert#)")
                .withNameMap(nameMap);

        _logger.info("Inserting #7:insert#: {}", #8:insert#);

        _#9:insert#.putItem(putItemSpec);
    }
