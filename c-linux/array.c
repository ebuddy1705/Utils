

enum nf_ip_trace_comments {
	NF_IP_TRACE_COMMENT_RULE,
	NF_IP_TRACE_COMMENT_RETURN,
	NF_IP_TRACE_COMMENT_POLICY,
};

static const char *const comments[] = {
	[NF_IP_TRACE_COMMENT_RULE]	= "rule",
	[NF_IP_TRACE_COMMENT_RETURN]	= "return",
	[NF_IP_TRACE_COMMENT_POLICY]	= "policy",
};


static const char *const hooknames[] = {
	[NF_INET_PRE_ROUTING]		= "PREROUTING",
	[NF_INET_LOCAL_IN]		= "INPUT",
	[NF_INET_FORWARD]		= "FORWARD",
	[NF_INET_LOCAL_OUT]		= "OUTPUT",
	[NF_INET_POST_ROUTING]		= "POSTROUTING",
};
