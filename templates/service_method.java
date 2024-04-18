        return ApiInvocation.invoke(() -> {
            if(#1:insert# == null)
                throw new MissingRequiredFieldException();

            final #2:insert# response = new #3:insert#();

            response.set#4:insert#(_#5:insert#.#6:insert#(#7:insert#));

            return response;
        });
