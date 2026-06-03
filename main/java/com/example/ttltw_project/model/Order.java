package com.example.ttltw_project.model.admin;

import com.example.ttltw_project.model.user.Shipping;

import java.sql.Timestamp;

public class Order {

        private int id;
        private int userId;
        private String orderCode;
        private Timestamp orderDate;
        private double totalPrice;
        private String status;
        private String recipientName;
        private String recipientPhone;
        private String shippingAddress;
        private String note;
//        private int paymentMethodId;
        private Shipping shipping;

        private String customerName;
        private String customerEmail;
        private String customerPhone;
        private String customerAddress;
        private String paymentMethod;
        private double shippingFee;
        private double grandTotal;
        private String returnStatus;
        private String returnImageUrl;
        private String returnVideoUrl;
        private String returnFeedback;
        private String returnAdminNote;
        private Timestamp returnRequestedAt;
        private Timestamp returnResolvedAt;

        public Order() {
        }

        public Order(int id, int userId, String orderCode, Timestamp orderDate, double totalPrice, String status,
                     String recipientName, String recipientPhone, String shippingAddress, String note,
                     int paymentMethodId, Shipping shipping, String customerName, String customerEmail,
                     String customerPhone, String customerAddress, String paymentMethod, double shippingFee) {
            this.id = id;
            this.userId = userId;
            this.orderCode = orderCode;
            this.orderDate = orderDate;
            this.totalPrice = totalPrice;
            this.status = status;
            this.recipientName = recipientName;
            this.recipientPhone = recipientPhone;
            this.shippingAddress = shippingAddress;
            this.note = note;
//            this.paymentMethodId = paymentMethodId;
            this.shipping = shipping;
            this.customerName = customerName;
            this.customerEmail = customerEmail;
            this.customerPhone = customerPhone;
            this.customerAddress = customerAddress;
            this.paymentMethod = paymentMethod;
            this.shippingFee = shippingFee;
            this.grandTotal = totalPrice + shippingFee;
        }


        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getOrderCode() {
            return orderCode;
        }

        public void setOrderCode(String orderCode) {
            this.orderCode = orderCode;
        }

        public Timestamp getOrderDate() {
            return orderDate;
        }

        public void setOrderDate(Timestamp orderDate) {
            this.orderDate = orderDate;
        }

        public double getTotalPrice() {
            return totalPrice;
        }

        public void setTotalPrice(double totalPrice) {
            this.totalPrice = totalPrice;
        }

        public String getStatus() {
            if (this.status == null || this.status.trim().isEmpty()) {
                return "Chờ xử lý";
            }
            return this.status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getRecipientName() {
            return recipientName;
        }

        public void setRecipientName(String recipientName) {
            this.recipientName = recipientName;
        }

        public String getRecipientPhone() {
            return recipientPhone;
        }

        public void setRecipientPhone(String recipientPhone) {
            this.recipientPhone = recipientPhone;
        }

        public String getShippingAddress() {
            return shippingAddress;
        }

        public void setShippingAddress(String shippingAddress) {
            this.shippingAddress = shippingAddress;
        }

        public String getNote() {
            return note;
        }

        public void setNote(String note) {
            this.note = note;
        }

//        public int getPaymentMethodId() {
//            return paymentMethodId;
//        }
//
//        public void setPaymentMethodId(int paymentMethodId) {
//            this.paymentMethodId = paymentMethodId;
//        }

        public Shipping getShipping() {
            return shipping;
        }

        public void setShipping(Shipping shipping) {
            this.shipping = shipping;
        }

        public String getCustomerName() {
            return customerName;
        }

        public void setCustomerName(String customerName) {
            this.customerName = customerName;
        }

        public String getCustomerEmail() {
            return customerEmail;
        }

        public void setCustomerEmail(String customerEmail) {
            this.customerEmail = customerEmail;
        }

        public String getCustomerPhone() {
            return customerPhone;
        }

        public void setCustomerPhone(String customerPhone) {
            this.customerPhone = customerPhone;
        }

        public String getCustomerAddress() {
            return customerAddress;
        }

        public void setCustomerAddress(String customerAddress) {
            this.customerAddress = customerAddress;
        }

        public String getPaymentMethod() {
            return paymentMethod;
        }

        public void setPaymentMethod(String paymentMethod) {
            this.paymentMethod = paymentMethod;
        }

        public double getShippingFee() {
            return shippingFee;
        }

        public void setShippingFee(double shippingFee) {
            this.shippingFee = shippingFee;
        }

        public double getGrandTotal() {
            return this.totalPrice + this.shippingFee;
        }

        public void setGrandTotal(double grandTotal) {
            this.grandTotal = grandTotal;
        }

        public void setOrder_code(String orderCode) {
            this.orderCode = orderCode;
        }

        public String getOrder_code() {
            return this.orderCode;
        }

        public void setOrder_date(Timestamp orderDate) {
            this.orderDate = orderDate;
        }

        public Timestamp getOrder_date() {
            return this.orderDate;
        }

        public void setTotal_price(double totalPrice) {
            this.totalPrice = totalPrice;
        }

        public double getTotal_price() {
            return this.totalPrice;
        }

        public void setRecipient_name(String recipientName) {
            this.recipientName = recipientName;
        }

        public String getRecipient_name() {
            return this.recipientName;
        }

        public void setRecipient_phone(String recipientPhone) {
            this.recipientPhone = recipientPhone;
        }

        public String getRecipient_phone() {
            return this.recipientPhone;
        }

        public void setShipping_address(String shippingAddress) {
            this.shippingAddress = shippingAddress;
        }

        public String getShipping_address() {
            return this.shippingAddress;
        }

        public String getReturnStatus() {
            return returnStatus;
        }

        public void setReturnStatus(String returnStatus) {
            this.returnStatus = returnStatus;
        }

        public String getReturnImageUrl() {
            return returnImageUrl;
        }

        public void setReturnImageUrl(String returnImageUrl) {
            this.returnImageUrl = returnImageUrl;
        }

        public String getReturnVideoUrl() {
            return returnVideoUrl;
        }

        public void setReturnVideoUrl(String returnVideoUrl) {
            this.returnVideoUrl = returnVideoUrl;
        }

        public String getReturnFeedback() {
            return returnFeedback;
        }

        public void setReturnFeedback(String returnFeedback) {
            this.returnFeedback = returnFeedback;
        }

        public String getReturnAdminNote() {
            return returnAdminNote;
        }

        public void setReturnAdminNote(String returnAdminNote) {
            this.returnAdminNote = returnAdminNote;
        }

        public Timestamp getReturnRequestedAt() {
            return returnRequestedAt;
        }

        public void setReturnRequestedAt(Timestamp returnRequestedAt) {
            this.returnRequestedAt = returnRequestedAt;
        }

        public Timestamp getReturnResolvedAt() {
            return returnResolvedAt;
        }

        public void setReturnResolvedAt(Timestamp returnResolvedAt) {
            this.returnResolvedAt = returnResolvedAt;
        }

}
