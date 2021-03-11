/**
 * Class that handles where and how the recipe section is presented to the user
 * @author Nuno Rebelo - 18022107
 */



/**
 * changes to recipe section and shows the approriate content. In this case, recipe titles.
 */
function showRecipeName(){
    const parent = document.getElementById("recipelist")
        while (parent.firstChild) {
    parent.firstChild.remove()
    }

    switchToContent("page_recipies");

    var tr, td;
    var table = document.getElementById("recipelist");
    var tbody = document.createElement("tbody");
    
    var auxRecipe = new Recipe();
    defaultRecipeList.splice(defaultRecipeList.indexOf(auxRecipe), 1);
   

    defaultRecipeList.forEach(function (auxRecipe){
        tr = document.createElement("tr");
        td = document.createElement("td");

        var image = document.createElement('img');
        image.setAttribute("src", auxRecipe.img);
       
        generateTd(td, auxRecipe.name);
        tr.appendChild(image);
        
        tr.appendChild(td);
        tbody.appendChild(tr);
    });
    table.appendChild(tbody);
};