
{addJsDef ELITRACK_CLIENT_ID=$ELITRACK_CLIENT_ID|escape:'html':'UTF-8'}
{addJsDef hash_enabled=$hash_enabled|escape:'html':'UTF-8'}
{addJsDef controller_name=$controller_name|escape:'html':'UTF-8'}
{addJsDef isoldguest=$isoldguest|escape:'html':'UTF-8'}
{literal}

<script>
// order confirm
var prod_id = "";
var unit_price = "";
var total_price = "";
var products = "";
var gtotal = 0;
</script>
{/literal}{foreach $products as $product}{literal}
<script>
prod_id = '{/literal}{$product.id_product}{literal}';
total_price = Math.round('{/literal}{$product.total_price_tax_excl}{literal}' * 100) / 100;
unit_price = Math.round('{/literal}{$product.unit_price_tax_excl}{literal}' * 100) / 100;
products += prod_id+':'+total_price+':'+unit_price+';';
gtotal += total_price;
</script>
{/literal}{/foreach}{literal}

<script type="text/javascript">
var pagename = '{/literal}{$controller_name}{literal}';
var elitrack_client_ids = '{/literal}{$ELITRACK_CLIENT_ID}{literal}';
var user_id = '{/literal}{$cookie->id_customer}{literal}';

var order_id = '{/literal}{$id_order}{literal}';
var order_amt = Math.round(gtotal * 100) /100;
products = products.slice(0, -1);

//var reg_date = new Date('{/literal}{$cookie->date_add|date_format:"%Y,%m,%d"}{literal}');
//var curr_date = new Date();
//var oneDay = 24*60*60*1000;
//var diffDays = Math.round(Math.abs((reg_date.getTime() - curr_date.getTime())/(oneDay)));

var hash_enabled = '{/literal}{$hash_enabled}{literal}';
var isold_guest = '{/literal}{$isoldguest}{literal}';

var ordercount = '{/literal}{Order::getCustomerOrders($cookie->id_customer)|@count}{literal}';
var newuser = "";

if(ordercount > 1) {
	newuser = 0;
}
else if(user_id == "") {
	if(isold_guest > 1) {
		newuser = 0;
	}
	else {
		newuser = 1;
	}
}
else {
	newuser = 1;
}

(function() {

if(hash_enabled == 1) {
	if(user_id == "") {
		user_id == "";
	}
	else {
		user_id = $.md5(user_id);
	}
}
else {
	user_id = "";
}

var script = document.createElement("script");
script.type = "text\/javascript";
script.charset = "UTF-8";
script.async = "async";
script.defer = "defer";
script.src = ("https:" == document.location.protocol ? "https"
: "http")
+
"://tck.elitrack.com/tag?page=transaction&aid="+elitrack_client_ids+"&cid="+user_id+"&new="+newuser+"&reference="+order_id+"&products="+products+"&totalPrice="+order_amt;
document.getElementsByTagName("head")[0].appendChild(script);
})();
</script>
{/literal}