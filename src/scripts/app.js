App = {
    web3Provider: null,
    contracts: {},

    init: async function() {
        return await App.initWeb3();
    },

    initWeb3: async function() {
        if (typeof web3 !== 'undefined') {
            App.web3Provider = web3.currentProvider;
            web3 = new Web3(web3.currentProvider);
        } else {
            App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
            web3 = new Web3(App.web3Provider);
        }
        return App.initContract();
    },

    initContract: function() {
        var json = './control.json';
        $.getJSON(json, function(data) {
            App.contracts.Control = TruffleContract(data);
            App.contracts.Control.setProvider(App.web3Provider);
        });
        
        return App.bindEvents();
    },

    bindEvents: function() {
        //$(document).on('click', '.btn-adopt', App.handleAdopt);
        $('#create').on('click', '#create',App.create);
        $('#hadAccount').on('click', App.hadAccount);
    },

    create: function() {
        var controller;
        web3.eth.getAccounts(function(error, accounts) {
            if (error) {
                console.log(error);
            }
            var account = accounts[0];
            App.contracts.Control.deployed().then(function(instance) {
                controller = instance;
                if ($("input[name='accountType']:checked").val() == "p") {
                    console.log("Create Patient Account");
                    return controller.createPatient($('#name').val(), parseInt($('#age').val()), parseInt($('#gender').val()),
                    {from: account});
                }
                else {
                    console.log("Create Doctor Account");
                    return controller.createDoctor($('#name').val(), parseInt($('#age').val()), parseInt($('#gender').val()),
                    {from: account});
                }
            }).then(function(result) {
                console.log(result);
            }).catch(function(err) {
                console.log(err.message);
            });
        });
        
    },

    hadAccount: function() {
        if ($("input[name='accountType']:checked").val() == "p") {
            console.log("Had Patient Account"); 
            $('#inter-patient').attr('style', 'display:block');
            $('#inter-doctor').attr('style', 'display:none'); 
            $('#approve').on('click', App.approve);
            $('#disapprove').on('click', App.disapprove);
        }
        else {
            console.log("Had Doctor Account");
            $('#inter-doctor').attr('style', 'display:block');
            $('#inter-patient').attr('style', 'display:none');
            $('#add').on('click', App.addrecord);
        }
    },

    approve: function() {
        var controller;
        web3.eth.getAccounts(function(error, accounts) {
            if (error) {
                console.log(error);
            }
            var account = accounts[0];
            App.contracts.Control.deployed().then(function(instance) {
                controller = instance;
                return controller.giveApproval(account, $('#doctorAddress').val(),
                    {from: account});
            }).then(function(result) {
                console.log(result);
            }).catch(function(err) {
                console.log(err.message);
            })
        });
    },

    disapprove: function() {
        var controller;
        web3.eth.getAccounts(function(error, accounts) {
            if (error) {
                console.log(error);
            }
            var account = accounts[0];
            App.contracts.Control.deployed().then(function(instance) {
                controller = instance;
                return controller.cancelApproval(account, $('#doctorAddress').val(),
                    {from: account});
            }).then(function(result) {
                console.log(result);
            }).catch(function(err) {
                console.log(err.message);
            })
        });
    },

    addrecord: function() {
        var controller;
        web3.eth.getAccounts(function(error, accounts) {
            if (error) {
                console.log(error);
            }
            var account = accounts[0];
            App.contracts.Control.deployed().then(function(instance) {
                controller = instance;
                return controller.addRecord($('#patientAddress').val(), account,
                    $('#symtom').val(), $('#diagnosis').val(),
                    {from: account});
            }).then(function(result) {
                console.log(result);
            }).catch(function(err) {
                console.log(err.message);
            })
        });
    }

};

$(window).on('load', function() {
    App.init();
});