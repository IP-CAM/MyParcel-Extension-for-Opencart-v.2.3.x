<?php
if(version_compare(VERSION, '2.2.0.0', '>=')) {
    trait MyparcelT {
        public function getTotal($total)
        {
            if ($this->cart->hasShipping() && isset($this->session->data['shipping_method'])) {

                if (!class_exists('MyParcel')) {
                    require_once DIR_SYSTEM . 'myparcelnl/class_myparcel.php';
                    MyParcel($this->registry);
                }

                if (MyParcel()->shipment->checkout->checkValidShippingMethod()) {

                    if (!empty($this->session->data['myparcel']['data'])) {

                        /** @var MyParcel_Shipment_Checkout $checkout_helper * */
                        $checkout_helper = MyParcel()->shipment->checkout;
                        $data = $this->session->data['myparcel'];

                        // Get current shipping title
                        $checkout_shipping_method = MyParcel()->shipment->shipment_helper->getShippingCodeByShippingQuote($this->session->data['shipping_method']['code']);

                        $total_array = $checkout_helper->getTotalArray($data, false, null, '', false);
                        $total_price = 0;

                        foreach ($total_array as $total_code => $total_item) {
                            $total_price += $total_item['price'];
                        }

                        if(version_compare(VERSION, '2.3.0.0', '>=')) {
                            $this->load->language('extension/shipping/' . $checkout_shipping_method);
                        } else {
                            $this->load->language('shipping/' . $checkout_shipping_method);
                        }

                        if ($total_price > 0) {
                            $total['totals'][] = array(
                                'code' => 'myparcel_total',
                                'title' => $this->config->get('myparcel_shipping_title') .
                                    '
							<a class="button-myparcel-total-details" data-collapse="1">'
                                    . MyParcel()->lang->get('entry_details') .
                                    '<i class="fa fa-caret-down"></i>
							</a>
						',
                                'value' => $total_price,
                                'sort_order' => $this->config->get('myparcel_total_sort_order')
                            );

                            $total['total'] += $total_price;
                        }
                    } else {
                        $session_data = $this->session->data;
                        if (!empty($session_data['shipping_method']['code']) && $session_data['shipping_method']['code'] == 'myparcel_shipping.myparcel_shipping') {
                            $total['totals'][] = array(
                                'code' => 'myparcel_total',
                                'title' => $this->config->get('myparcel_shipping_title'),
                                'value' => $this->config->get('myparcel_shipping_cost'),
                                'sort_order' => $this->config->get('shipping_sort_order')
                            );
                        }
                    }
                }
            }
        }
    }
} else {
    trait MyparcelT {
        public function getTotal(&$totals, &$price, &$taxes)
        {
            if ($this->cart->hasShipping() && isset($this->session->data['shipping_method'])) {

                if (!class_exists('MyParcel')) {
                    require_once DIR_SYSTEM . 'myparcelnl/class_myparcel.php';
                    MyParcel($this->registry);
                }

                if (MyParcel()->shipment->checkout->checkValidShippingMethod()) {

                    if (!empty($this->session->data['myparcel']['data'])) {

                        /** @var MyParcel_Shipment_Checkout $checkout_helper * */
                        $checkout_helper = MyParcel()->shipment->checkout;
                        $data = $this->session->data['myparcel'];

                        // Get current shipping title
                        $checkout_shipping_method = MyParcel()->shipment->shipment_helper->getShippingCodeByShippingQuote($this->session->data['shipping_method']['code']);

                        $total_array = $checkout_helper->getTotalArray($data, false, null, '', false);
                        $total_price = 0;

                        foreach ($total_array as $total_code => $total_item) {
                            $total_price += $total_item['price'];
                        }

                        if(version_compare(VERSION, '2.3.0.0', '>=')) {
                            $this->load->language('extension/shipping/' . $checkout_shipping_method);
                        } else {
                            $this->load->language('shipping/' . $checkout_shipping_method);
                        }

                        if ($total_price > 0) {
                            $totals[] = array(
                                'code' => 'myparcel_total',
                                'title' => $this->config->get('myparcel_shipping_title') .
                                    '
							<a class="button-myparcel-total-details" data-collapse="1">'
                                    . MyParcel()->lang->get('entry_details') .
                                    '<i class="fa fa-caret-down"></i>
							</a>
						',
                                'value' => $total_price,
                                'sort_order' => $this->config->get('myparcel_total_sort_order')
                            );

                            $price += $total_price;
                        }
                    }
                }
            }
        }
    }
}