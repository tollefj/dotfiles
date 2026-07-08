v() {
    nvim .
}

# %%%%%%%%%% LATEX STUFF %%%%%%%%%%%
function ltx() {
  if [[ -z "$1" ]]; then
    echo "Usage: latex_compile <main_file_without_extension>"
    return 1
  fi

  local main_file="$1"

  echo "Compiling $main_file.tex..."
  pdflatex "$main_file.tex"

  if [[ -f "$main_file.bcf" ]]; then
    echo "Running Biber..."
    biber "$main_file"
  fi

  if [[ -f "$main_file.ist" ]]; then
    echo "Making glossaries..."
    makeglossaries "$main_file"
  fi

  echo "Running pdflatex twice more to resolve references..."
  pdflatex "$main_file.tex"
  pdflatex "$main_file.tex"

  echo "Compilation complete for $main_file.tex"
}

latex-build() {
  local tex_files=(*.tex)

  if [ ${#tex_files[@]} -eq 0 ]; then
    echo "❌ No .tex files found in the current directory."
    return 1
  fi

  echo "📄 Select a .tex file to build:"
  select choice in "${tex_files[@]}"; do
    if [[ -n "$choice" ]]; then
      name="${choice%.tex}"
      break
    else
      echo "❌ Invalid selection. Please choose a number."
    fi
  done

  echo -n "📦 Do you want to create a zip of the entire folder after build? (y/n): "
  read zip_choice

  echo "🔧 Building $name.tex..."
  if ! pdflatex -shell-escape "$name.tex"; then echo "❌ pdflatex failed"; return 1; fi
  if ! bibtex "$name"; then echo "❌ bibtex failed"; return 1; fi
  if ! pdflatex -shell-escape "$name.tex"; then echo "❌ pdflatex 2nd pass failed"; return 1; fi
  if ! pdflatex -shell-escape "$name.tex"; then echo "❌ pdflatex 3rd pass failed"; return 1; fi

  echo "✅ Build complete: $name.pdf"

  if [[ "$zip_choice" =~ ^[Yy]$ ]]; then
    local current_dir
    current_dir=$(basename "$PWD")
    local parent_dir
    parent_dir=$(dirname "$PWD")
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local zip_name="${current_dir}_build_${timestamp}.zip"

    echo "📦 Zipping entire folder to: $parent_dir/$zip_name"
    (cd .. && zip -r "$zip_name" "$current_dir" > /dev/null)

    if [ -f "$parent_dir/$zip_name" ]; then
      echo "✅ Archive created: $zip_name"
    else
      echo "⚠️  ZIP creation failed."
    fi
  fi
}
