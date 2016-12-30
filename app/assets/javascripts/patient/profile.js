$(document).ready(function() {
  // Smart Wizard
  $('#wizard').smartWizard({
        onLeaveStep:leaveAStepCallback,
        onFinish:onFinishCallback
    });

    function leaveAStepCallback(obj, context){
        // alert("Leaving step " + context.fromStep + " to go to step " + context.toStep);
        return validateSteps(context.fromStep); // return false to stay on step and true to continue navigation 
    }

    function onFinishCallback(objs, context){
        if(validateAllSteps()){
            $('.profile-form').submit();
        } else {
            $('.alert').html('Please fill all required fields')
            $('.alert').show().fadeOut(7000);
        }
    }

    // Your Step validation logic
    function validateSteps(stepnumber){
        var isStepValid = true;
        // validate step 1
        if(stepnumber == 1){
            // Your step validation logic
            // set isStepValid = false if has errors
        }
        return isStepValid;
        // ...      
    }
    function validateAllSteps(){
        var isStepValid = true;
        // all step validation logic     
        return $('.profile-form')[0].checkValidity();
    }
});
