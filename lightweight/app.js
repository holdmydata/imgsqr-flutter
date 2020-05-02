
/* 
   ----------------------------------------------------------------------------------------
   ----------------------------  DOCUMENT FUNCTIONS  --------------------------------------
   ----------------------------------------------------------------------------------------
*/

$(document).ready(function() {
    try {
        image = new ImageInterface();
        $('#loadDappMessage').append("Image Contract Loaded at " + getRopstenAddressLink(image.address) + "</br>");
    } catch(error) {
        $('#loadDappMessage').append("<span class='bad'>ERROR:</span> Image Contract could not load:</br>" + error + "</br>");
    }
    try {
        contract = new ContractInterface();
        $('#loadDappMessage').append("License Contract Loaded at " + getRopstenAddressLink(contract.address) + "</br>");
    } catch(error) {
        $('#loadDappMessage').append("<span class='bad'>ERROR:</span> License Contract could not load:</br>" + error + "</br>");
    }
});

/* This function is a complete hack, but I think there's a bug in this version of web3 or something.
 * If you look at contract-helper.js, there are three event listeners defined to listen to three separate
 * events emited by the contracts: 
 *  1. Image created
 *  2. License Contract created
 *  3. License Contract approved
 * 
 *   (look for: // =================== BEGIN EVENT LISTENER # ======================= )
 * 
 * If you watch the console when you hit one of those respective buttons, you'll notice that the callback function
 * for either of those will be run three times. Not all three callback functions being run; the same callback function
 * for the correct event will be called three times. However, if you comment out two of the other listeners and
 * call a function with the listner you still have setup, it will only call that callback function once.
 * 
 * This trimOutput function keeps all three of those outputs from being displayed to the screen.
 */
function trimOutput(outputWindowId, numLinesToDisplay) {
    let finalOutput = $(outputWindowId).html().split("<br>").slice(0, numLinesToDisplay);
    $(outputWindowId).empty();
    $(outputWindowId).html(finalOutput.join('<br>'));
}


/* 
   ----------------------------------------------------------------------------------------
   -------------------------  IMAGE CONTRACT FUNCTIONS  -----------------------------------
   ----------------------------------------------------------------------------------------
*/

var imageList;
var imgListPos;

function createImage() {

    $('#addImageMessage').empty();
    $('#addImageMessage').val("Creating Image...</br>");



    function afterSubmitCallbackFunction(error, txHash) {
        if (!error) {
            $('#addImageMessage').append("Creating Image...</br>");
            $('#addImageMessage').append("tx: " + getRopstenTxLink(txHash) + "</br>");
            $('#addImageMessage').append("Waiting");
            $('#addImageMessage').addClass("loading");
        } else {
            $('#addImageMessage').append("ERROR:</br>");
            $('#addImageMessage').append(error.stack);
            console.log(error);
        }
        
    }

    function afterConfirmedCallbackFunction(error, data, owner, id) {
        $('#addImageMessage').removeClass("loading");
        $('#addImageMessage').append("...</br>");
        if (!error) {
            $('#addImageMessage').append("<span class='good'>Creation successful</span></br></br>");
            $('#addImageMessage').append("<b>ID:</b> " + id + "</br>");
            $('#addImageMessage').append("<b>Owner:</b> " + owner + "</br></br>");
            trimOutput('#addImageMessage', 7);
        } else {
            $('#addImageMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#addImageMessage').append(error.stack);
            console.log(error);
        }
    }


    image.createImage(name=$('#imgName').val(), 
                      description=$('#imgDescription').val(),
                      externalPointer=$('#imgURL').val(),
                      afterSubmitCallbackFunction=afterSubmitCallbackFunction,
                      afterConfirmedCallbackFunction=afterConfirmedCallbackFunction);
}

function getImage() {

    $('#readImageMessage').empty();
    $('#readImageMessage').val("Retrieving Image...</br>");

    function callbackFunction(error, img) {
        if (!error) {
            $('#readImageMessage').append("<span class='good'>Image retrieved</span></br>");
            $('#readImageMessage').append("</br><pre><code>" + JSON.stringify(img, null, 2) + "</code></pre></br>");

            $('#imgCardImage').attr("src",img.externalPointer);
            $('#imgCardTitle').text(img.name);
            $('#imgCardDescription').text(img.description);
        } else {
            $('#readImageMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#readImageMessage').append(error.stack);
            console.log(error);
        }
        
    }

    image.getImageById(id=$('#imgIdentityHash').val(),
                       callbackFunction=callbackFunction);

}

function getAllImages() {

    $('#readAllImagesMessage').empty();
    $('#readAllImagesMessage').val("Retrieving Images...</br>");

    function callbackFunction(error, images) {
        
        if (!error) {
            $('#readAllImagesMessage').append("<span class='good'>Images retrieved</span></br>");
            window.imageList = images;
            window.imageListPos = 0;
            displayImageAtPostion(imageListPos);
        } else {
            $('#readAllImagesMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#readAllImagesMessage').append(error.stack);
            console.log(error);
        }
        
    }

    image.getAllImages(callbackFunction);  
}

function displayImageAtPostion(position) {
    $('#imgPosCardImage').attr("src",window.imageList[position].externalPointer);
    $('#imgPosCardTitle').text(window.imageList[position].name);
    $('#imgPosCardDescription').text(window.imageList[position].description);
    $('#imgPosCardId').text(window.imageList[position].id);
}

function transitionNextImageCard() {
    window.imageListPos = (window.imageListPos + 1) % imageList.length;
    displayImageAtPostion(window.imageListPos);
}


/* 
   ----------------------------------------------------------------------------------------
   ------------------------  LICENSE CONTRACT FUNCTIONS  ----------------------------------
   ----------------------------------------------------------------------------------------
*/

function createLicenseContract() {

    $('#createContractMessage').empty();
    $('#createContractMessage').append("Creating License Contract...</br>");

    function afterSubmitCallbackFunction(error, txHash) {
        if (!error) {
            $('#createContractMessage').append("tx: " + getRopstenTxLink(txHash) + "</br>");
            $('#createContractMessage').append("Waiting");
            $('#createContractMessage').addClass("loading");
        } else {
            $('#createContractMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#createContractMessage').append(error.stack);
            console.log(error);
        }
        
    }

    function afterConfirmedCallbackFunction(error, data, initiator, id) {
        $('#createContractMessage').removeClass("loading");
        $('#createContractMessage').append("...</br>");
        if (!error) {
            $('#createContractMessage').append("<span class='good'>Creation successful</span></br></br>");
            $('#createContractMessage').append("<b>ID:</b> " + id + "</br>");
            $('#createContractMessage').append("<b>Initiator:</b> " + initiator + "</br></br>");
            trimOutput('#createContractMessage', 7);
        } else {
            $('#createContractMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#createContractMessage').append(error.stack);
            console.log(error);
        }
    }

    contract.createContract(licensor=$('#conLicensor').val(), 
                            licensee=$('#conLicensee').val(), 
                            assetId=$('#conImgId').val(), 
                            fee=$('#conFee').val(), 
                            afterSubmitCallbackFunction=afterSubmitCallbackFunction,
                            afterConfirmedCallbackFunction=afterConfirmedCallbackFunction);
}

function readLicenseContract() {

    ['#licensorApprovedIndicator', '#licenseeApprovedIndicator', '#executedIndicator', '#canceledIndicator'].forEach( obj => {
        $(obj).removeClass('statusTrue');
        $(obj).removeClass('statusFalse');
    })

    $('#readContractMessage').empty();
    $('#readContractMessage').append("Retrieving Contract...</br>");
    
    function callbackFunction(error, returnContract) {
        if (!error) {
            $('#readContractMessage').append("<span class='good'>Contract retrieved</span></br>");
            $('#readContractMessage').append("</br><pre><code>" + JSON.stringify(returnContract, null, 2) + "</code></pre></br>");

            if (returnContract.licensorApproved) {
                $('#licensorApprovedIndicator').addClass('statusTrue');
            } else {
                $('#licensorApprovedIndicator').addClass('statusFalse');
            }
            if (returnContract.licenseeApproved) {
                $('#licenseeApprovedIndicator').addClass('statusTrue');
            } else {
                $('#licenseeApprovedIndicator').addClass('statusFalse');
            }
            if (returnContract.executed) {
                $('#executedIndicator').addClass('statusTrue');
                $('#readContractMessage').append('<img id="patOnBack" src="https://media0.giphy.com/media/3oFzmbl7X4uIyj2wrm/giphy.gif">');
            } else {
                $('#executedIndicator').addClass('statusFalse');
            }
            if (returnContract.canceled) {
                $('#canceledIndicator').addClass('statusTrue');
            } else {
                $('#canceledIndicator').addClass('statusFalse');
            }

        } else {
            $('#readContractMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#readContractMessage').append(error.stack);
            console.log(error);
        }
        
    }

    contract.getContract(id=$('#readContractId').val(),
                        callbackFunction=callbackFunction);
    
}

function approveContract() {

    $('#approveContractMessage').empty();
    $('#approveContractMessage').append("Approving License Contract " + $('#approveContractId').val() + " ...</br>");

    function afterSubmitCallbackFunction(error, txHash) {
        if (!error) {
            $('#approveContractMessage').append("tx: " + getRopstenTxLink(txHash) + "</br>");
            $('#approveContractMessage').append("Waiting");
            $('#approveContractMessage').addClass("loading");
        } else {
            $('#approveContractMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#approveContractMessage').append(error.stack);
            console.log(error);
        }
        
    }

    function afterConfirmedCallbackFunction(error, data, initiator, id) {
        $('#approveContractMessage').removeClass("loading");
        $('#approveContractMessage').append("...</br>");
        if (!error) {
            $('#approveContractMessage').append("<span class='good'>Approval successful</span></br></br>");
            $('#approveContractMessage').append("<b>ID:</b> " + id + "</br>");
            $('#approveContractMessage').append("<b>Initiator:</b> " + initiator + "</br></br>");
            trimOutput('#approveContractMessage', 7);
        } else {
            $('#approveContractMessage').append("<span class='bad'>ERROR:</span></br>");
            $('#approveContractMessage').append(error.stack);
            console.log(error);
        }
    }

    contract.approveContract(contractId=$('#approveContractId').val(), 
                            payment=$('#contractPayment').val(), 
                            afterSubmitCallbackFunction=afterSubmitCallbackFunction,
                            afterConfirmedCallbackFunction=afterConfirmedCallbackFunction);
}