    public List<#1:insert#> #2:insert#(final #3:insert# request) throws Exception
    {
        final long begin = request.get #4:insert#
        final long end = request.get #5:insert#
        RangeKeyCondition rangeKeyCondition = new RangeKeyCondition(#6:insert#.INDEX_TIMESTAMP_RANGEKEY_NAME)
                .between(begin, end);

        final QuerySpec query = new QuerySpec()
                .withHashKey(#7:insert#.INDEX_TIMESTAMP_HASHKEY_NAME, request.get#8:insert#().toString())
                .withRangeKeyCondition(rangeKeyCondition);

        final Index timestampIndex = _#9:insert#.getIndex(#10:insert#.INDEX_TIMESTAMP_NAME);

        final List<#11:insert#> retVal = new ArrayList<>();

        for (Page<Item, QueryOutcome> page : timestampIndex.query(query).pages())
        {
            Iterator<Item> itemIterator = page.iterator();
            while(itemIterator.hasNext())
            {
                retVal.add(_objectMapper.readValue(itemIterator.next().toJSON(), #12:insert#.class);
            }
        }
        return retVal;
    }
