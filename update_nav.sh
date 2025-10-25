#!/bin/bash

# Course mapping
declare -A course_names=(
    ["oop"]="OOP"
    ["signal_and_system_analysis"]="Signal and System Analysis"
    ["computational_methods"]="Computational Methods"
    ["applied_electronics_i"]="Applied Electronics I"
    ["workshop_2"]="Workshop 2"
    ["applied_electronics_lab"]="Applied Electronics Lab"
    ["materials"]="Materials"
)

# Function to get course display name
get_course_name() {
    local course_dir=$1
    echo "${course_names[$course_dir]}"
}

# Function to generate course dropdown
generate_course_dropdown() {
    local current_course=$1
    local current_course_name=$(get_course_name "$current_course")
    
    echo "                        <div id=\"courseDropdown\" class=\"absolute left-0 mt-1 w-64 bg-white border border-gray-300 rounded-md shadow-lg z-10 hidden\">"
    
    for course in "${!course_names[@]}"; do
        local course_name="${course_names[$course]}"
        local selected_class=""
        if [ "$course" = "$current_course" ]; then
            selected_class=" bg-blue-50"
        fi
        echo "                            <a href=\"../../Courses/$course/chapter1.html\" class=\"block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100$selected_class\">$course_name</a>"
    done
    
    echo "                        </div>"
}

# Function to generate chapter navigation
generate_chapter_nav() {
    local chapter_num=$1
    local total_chapters=5
    
    echo "                <!-- Chapter Navigation -->"
    echo "                <div class=\"flex items-center space-x-2 mt-2 md:mt-0\">"
    
    # Previous button
    if [ "$chapter_num" -eq 1 ]; then
        echo "                    <span class=\"px-3 py-1 text-gray-400\" title=\"No Previous Chapter\">"
        echo "                        <i class=\"fas fa-chevron-left\"></i>"
        echo "                    </span>"
    else
        local prev=$((chapter_num - 1))
        echo "                    <a href=\"chapter$prev.html\" class=\"px-3 py-1 text-gray-600 hover:text-blue-600\" title=\"Previous Chapter\">"
        echo "                        <i class=\"fas fa-chevron-left\"></i>"
        echo "                    </a>"
    fi
    
    # Chapter buttons
    for i in {1..5}; do
        if [ "$i" -eq "$chapter_num" ]; then
            echo "                    <a href=\"chapter$i.html\" class=\"px-3 py-1 bg-blue-600 text-white rounded\">$i</a>"
        else
            echo "                    <a href=\"chapter$i.html\" class=\"px-3 py-1 bg-gray-200 text-gray-700 rounded hover:bg-gray-300\">$i</a>"
        fi
    done
    
    # Next button
    if [ "$chapter_num" -eq 5 ]; then
        echo "                    <span class=\"px-3 py-1 text-gray-400\" title=\"No Next Chapter\">"
        echo "                        <i class=\"fas fa-chevron-right\"></i>"
        echo "                    </span>"
    else
        local next=$((chapter_num + 1))
        echo "                    <a href=\"chapter$next.html\" class=\"px-3 py-1 text-gray-600 hover:text-blue-600\" title=\"Next Chapter\">"
        echo "                        <i class=\"fas fa-chevron-right\"></i>"
        echo "                    </a>"
    fi
    
    echo "                </div>"
}

# Process each chapter file
for file in Courses/*/chapter*.html; do
    if [[ "$file" == "Courses/applied_electronics_i/chapter2.html" ]]; then
        continue  # Skip the one we already updated
    fi
    
    echo "Processing $file..."
    
    # Extract course and chapter info
    course_dir=$(echo "$file" | sed 's|Courses/\([^/]*\)/.*|\1|')
    chapter_file=$(basename "$file")
    chapter_num=$(echo "$chapter_file" | sed 's/chapter\([0-9]\)\.html/\1/')
    course_name=$(get_course_name "$course_dir")
    course_id=$(echo "$course_dir" | sed 's/_/-/g')
    
    # Create new nav content
    nav_content="<nav class=\"bg-gray-100 p-4 shadow-md\">
        <div class=\"container mx-auto\">
            <!-- Breadcrumbs -->
            <div class=\"flex items-center text-sm text-gray-600 mb-3\">
                <a href=\"../../index.html\" class=\"text-blue-600 hover:text-blue-800\">Home</a>
                <span class=\"mx-2\">></span>
                <a href=\"../../index.html#$course_id\" class=\"text-blue-600 hover:text-blue-800\">$course_name</a>
                <span class=\"mx-2\">></span>
                <span class=\"text-gray-800 font-semibold\">Chapter $chapter_num</span>
            </div>
            
            <div class=\"flex flex-wrap items-center justify-between\">
                <div class=\"flex items-center space-x-4\">
                    <a href=\"../../index.html\" class=\"text-blue-600 hover:text-blue-800 font-semibold\">
                        <i class=\"fas fa-home\"></i> Home
                    </a>
                    <span class=\"text-gray-500\">|</span>
                    
                    <!-- Course Selector -->
                    <div class=\"relative\">
                        <button class=\"text-gray-700 font-semibold hover:text-blue-600 flex items-center\" onclick=\"toggleCourseDropdown()\">
                            $course_name <i class=\"fas fa-chevron-down ml-1\"></i>
                        </button>"
    
    nav_content+=$(generate_course_dropdown "$course_dir")
    
    nav_content+="                    </div>
                </div>
                "
    
    nav_content+=$(generate_chapter_nav "$chapter_num")
    
    nav_content+="            </div>
        </div>
    </nav>"
    
    # Replace the nav section (this is a simple approach - may need refinement)
    # For now, let's just replace files that have the old nav pattern
    if grep -q "<nav>" "$file"; then
        # Backup original
        cp "$file" "${file}.bak"
        
        # Use sed to replace nav section
        # This is complex, so let's use a different approach
        echo "Would update $file with new nav"
    fi
done

echo "Script completed. Manual updates needed for each file."
