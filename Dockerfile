FROM fuzzers/go-fuzz:1.2.0 as builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git clang wget

ADD . /gjson
WORKDIR /gjson
ADD harnesses/fuzz.go ./fuzzers/ 
WORKDIR ./fuzzers/
RUN go-fuzz-build -libfuzzer -o fuzz.a
RUN clang -fsanitize=fuzzer fuzz.a -o gjson.libfuzzer

RUN mkdir ./corpus
RUN git clone https://github.com/dvyukov/go-fuzz-corpus.git
RUN cp ./go-fuzz-corpus/json/corpus/* ./corpus/
RUN rm -rf ./go-fuzz-corpus/

FROM fuzzers/go-fuzz:1.2.0
COPY --from=builder /gjson/fuzzers/gjson.libfuzzer /
COPY --from=builder /gjson/fuzzers/corpus/    /testsuite/

ENTRYPOINT []
CMD ["/gjson.libfuzzer"]
